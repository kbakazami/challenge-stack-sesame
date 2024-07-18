use diesel::{prelude::*, r2d2::ConnectionManager, result::Error};
use r2d2::PooledConnection;

use crate::models::feedback::{Feedback, NewFeedback};
use crate::schema::feedback::dsl::{creationdate, feedback};
use crate::schema::feedback::{score, score_clean, score_global, score_time};

pub async fn create_feedback(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    new_feedback: NewFeedback,
) -> Result<Feedback, Error> {
    let new_feedback = NewFeedback {
        comment: new_feedback.comment,
        score: new_feedback.score,
        user_id: new_feedback.user_id,
        toilet_id: new_feedback.toilet_id,
        score_clean: new_feedback.score_clean,
        score_time: new_feedback.score_time,
        score_global: new_feedback.score_global,
    };

    diesel::insert_into(feedback)
        .values(new_feedback)
        .get_result::<Feedback>(&mut conn)
}

pub async fn get_avg_score(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
) -> Result<Vec<(String, f64, f64, f64, f64)>, Error> {
    let formatted_results = match feedback
        .group_by(creationdate)
        .select((
            creationdate,
            diesel::dsl::avg(score).nullable(),
            diesel::dsl::avg(score_time).nullable(),
            diesel::dsl::avg(score_clean).nullable(),
            diesel::dsl::avg(score_global).nullable(),
        ))
        .load::<(
            chrono::NaiveDateTime,
            Option<f64>,
            Option<f64>,
            Option<f64>,
            Option<f64>,
        )>(&mut conn)
    {
        Ok(items) => items
            .iter()
            .map(
                |(date, avg_score, avg_score_time, avg_score_clean, avg_score_global)| {
                    let formatted_date = date.format("%Y-%m-%d").to_string();
                    (
                        formatted_date,
                        avg_score.unwrap_or(0.0),
                        avg_score_time.unwrap_or(0.0),
                        avg_score_clean.unwrap_or(0.0),
                        avg_score_global.unwrap_or(0.0),
                    )
                },
            )
            .collect::<Vec<(String, f64, f64, f64, f64)>>(),
        Err(err) => {
            return Err(err);
        }
    };
    Ok(formatted_results)
}
