use chrono::{Datelike, NaiveDate, NaiveDateTime, Utc};
use diesel::{prelude::*, r2d2::ConnectionManager, result::Error};
use r2d2::PooledConnection;

use crate::models::users::{NewUsers, Users, UsersWithoutToken};
use crate::schema::users::dsl::{id, users};
use crate::schema::users::{birthdate, civility};

pub async fn create_user(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    new_user: NewUsers,
) -> Result<Users, Error> {
    let new_user = NewUsers {
        firstname: new_user.firstname,
        lastname: new_user.lastname,
        civility: new_user.civility,
        birthdate: new_user.birthdate,
        email: new_user.email,
        token: new_user.token,
        role_id: new_user.role_id,
    };

    diesel::insert_into(users)
        .values(new_user)
        .get_result::<Users>(&mut conn)
}

pub async fn get_user(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    new_id: uuid::Uuid,
) -> Result<UsersWithoutToken, Error> {
    match users.filter(id.eq(new_id)).get_result::<Users>(&mut conn) {
        Ok(user) => Ok(UsersWithoutToken {
            id: user.id,
            firstname: user.firstname.clone(),
            lastname: user.lastname.clone(),
            email: user.email.clone(),
            birthdate: user.birthdate,
            civility: user.civility,
            role_id: user.role_id,
        }),
        Err(err) => return Err(err),
    }
}

pub async fn get_users(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
) -> Result<Vec<UsersWithoutToken>, Error> {
    Ok(match users.load::<Users>(&mut conn) {
        Ok(items) => items
            .iter()
            .map(|user| UsersWithoutToken {
                id: user.id,
                firstname: user.firstname.clone(),
                lastname: user.lastname.clone(),
                email: user.email.clone(),
                birthdate: user.birthdate,
                civility: user.civility,
                role_id: user.role_id,
            })
            .collect::<Vec<UsersWithoutToken>>(),
        Err(err) => return Err(err),
    })
}

pub async fn get_proportion(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
) -> Result<Vec<(i32, i32)>, Error> {
    let current_date = Utc::now().naive_utc();
    let users_data = users
        .select((civility, birthdate))
        .load::<(i32, NaiveDate)>(&mut conn)?;

    let results = users_data
        .into_iter()
        .map(|(other_civility, other_birthdate)| {
            let age = calculate_age(other_birthdate, current_date);
            (other_civility, age)
        })
        .collect::<Vec<(i32, i32)>>();

    Ok(results)
}

fn calculate_age(var_birthdate: NaiveDate, current_date: NaiveDateTime) -> i32 {
    let mut age = current_date.year() - var_birthdate.year();
    if current_date.month() < var_birthdate.month()
        || (current_date.month() == var_birthdate.month()
            && current_date.day() < var_birthdate.day())
    {
        age -= 1;
    }
    age
}

pub async fn delete_user(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    id_user: uuid::Uuid,
) -> Result<(String, uuid::Uuid), Error> {
    let result = match diesel::delete(users.find(id_user)).execute(&mut conn) {
        Ok(_) => {
            let message = format!("Deleted user with id: {}", id_user);
            (message, id_user)
        }
        Err(err) => return Err(err),
    };
    Ok(result)
}
