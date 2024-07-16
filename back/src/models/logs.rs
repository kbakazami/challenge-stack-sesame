use chrono::NaiveDateTime;
use diesel::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Queryable, Selectable, Serialize)]
#[diesel(table_name = crate::schema::logs)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Logs {
    pub id: i32,
    pub type_: i32,
    pub error: Option<String>,
    pub creationdate: NaiveDateTime,
    pub toilet_id: uuid::Uuid
}

#[derive(Insertable, Deserialize, Serialize)]
#[diesel(table_name = crate::schema::logs)]
pub struct NewLogs {
    pub type_: i32,
    pub error: Option<String>,
    pub toilet_id: uuid::Uuid
}
