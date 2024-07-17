use diesel::{prelude::*, r2d2::ConnectionManager, result::Error};
use r2d2::PooledConnection;

use crate::models::users::{NewUsers, Users};
use crate::schema::users::dsl::{users, id};

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
) -> Result<Users, Error> {
    match users
        .filter(id.eq(new_id))
        .get_result::<Users>(&mut conn)
    {
        Ok(item) => Ok(item),
        Err(err) => return Err(err),
    }
}
