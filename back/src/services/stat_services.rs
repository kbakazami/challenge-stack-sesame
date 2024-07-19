use chrono::{Datelike, NaiveDateTime, Timelike, Weekday};
use diesel::{prelude::*, r2d2::ConnectionManager, result::Error};
use r2d2::PooledConnection;

use crate::{
    models::{logs::{Logs, NewLogs}, toilet_status::ToiletStatus},
    schema::{
        logs::{
            creationdate,
            dsl::{id, logs, toilet_id, type_},
        },
        toilet::dsl::{id as id_toilet, toilet},
    },
};

pub async fn create_log(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    new_log: NewLogs,
) -> Result<Logs, Error> {
    let new_log = NewLogs {
        type_: new_log.type_,
        error: new_log.error,
        toilet_id: new_log.toilet_id,
    };

    diesel::insert_into(logs)
        .values(new_log)
        .get_result::<Logs>(&mut conn)
}

pub async fn get_log_nb_passage(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
) -> Result<Vec<(String, i32)>, Error> {
    let formatted_results = match logs
        .inner_join(toilet.on(toilet_id.eq(id_toilet)))
        .filter(type_.eq(ToiletStatus::Used.id()))
        .group_by(creationdate)
        .select((creationdate, diesel::dsl::count(id)))
        .load::<(chrono::NaiveDateTime, i64)>(&mut conn)
    {
        Ok(items) => items
            .iter()
            .map(|(date, count)| {
                let formatted_date = date.format("%Y-%m-%d").to_string();
                (formatted_date, *count as i32)
            })
            .collect::<Vec<(String, i32)>>(),
        Err(err) => {
            return Err(err);
        }
    };
    Ok(formatted_results)
}

pub async fn get_affluence(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
) -> Result<Vec<(u32, Weekday, i32)>, Error> {
    let formatted_results = match logs
        .filter(type_.eq(1))
        .group_by(creationdate) // Remove date_trunc from group_by
        .select((creationdate, diesel::dsl::count_star()))
        .load::<(NaiveDateTime, i64)>(&mut conn)
    {
        Ok(items) => items
            .iter()
            .map(|(datetime, count)| {
                let hour = NaiveDateTime::new(
                    datetime.date(),
                    chrono::NaiveTime::from_hms_opt(datetime.time().hour(), 0, 0).unwrap(),
                );
                let day = NaiveDateTime::new(
                    datetime.date(),
                    chrono::NaiveTime::from_hms_opt(0, 0, 0).unwrap(),
                );
                (hour.hour(), day.weekday(), *count as i32)
            })
            .collect::<Vec<(u32, Weekday, i32)>>(),
        Err(err) => {
            return Err(err);
        }
    };
    Ok(formatted_results)
}
