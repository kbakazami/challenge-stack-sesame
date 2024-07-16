use chrono::NaiveDateTime;
use diesel::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Queryable, Selectable, Serialize)]
#[diesel(table_name = crate::schema::access)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Access {
    pub id: uuid::Uuid,
    pub api_key: String,
    pub api_secret: String,
    pub api_consumer: String,
    pub creationdate: NaiveDateTime,
    pub active: i16
}

#[derive(Insertable, Deserialize, Serialize)]
#[diesel(table_name = crate::schema::access)]
pub struct NewAccess {
    pub api_key: String,
    pub api_secret: String,
    pub api_consumer: String,
}
