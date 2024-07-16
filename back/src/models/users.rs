use chrono::NaiveDate;
use diesel::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Queryable, Selectable, Serialize)]
#[diesel(table_name = crate::schema::users)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Users {
    pub id: uuid::Uuid,
    pub civility: i32,
    pub lastname: String,
    pub firstname: String,
    pub birthdate: NaiveDate,
    pub email: String,
    pub token: Option<String>,
    pub role_id: i32
}

#[derive(Insertable, Deserialize, Serialize)]
#[diesel(table_name = crate::schema::users)]
pub struct NewUsers {
    pub civility: i32,
    pub lastname: String,
    pub firstname: String,
    pub birthdate: NaiveDate,
    pub email: String,
    pub token: Option<String>,
    pub role_id: i32
}
