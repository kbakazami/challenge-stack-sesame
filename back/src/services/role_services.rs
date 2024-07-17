use diesel::{prelude::*, r2d2::ConnectionManager, result::Error};
use r2d2::PooledConnection;

use crate::models::role::Role;
use crate::schema::role::dsl::role;

pub async fn get_roles(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>
) -> Result<Vec<Role>, Error> {
    match role
        .load::<Role>(&mut conn)
    {
        Ok(item) => Ok(item),
        Err(err) => return Err(err),
    }
}
