use chrono::NaiveDateTime;
use diesel::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Queryable, Selectable, Serialize)]
#[diesel(table_name = crate::schema::feedback)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Feedback {
    pub id: uuid::Uuid,
    pub title: String,
    pub comment: Option<String>,
    pub score: i32,
    pub creationdate: NaiveDateTime,
    pub user_id: uuid::Uuid,
    pub toilet_id: uuid::Uuid
}

#[derive(Insertable, Deserialize, Serialize)]
#[diesel(table_name = crate::schema::feedback)]
pub struct NewFeedback {
    pub title: String,
    pub comment: Option<String>,
    pub score: i32,
    pub user_id: uuid::Uuid,
    pub toilet_id: uuid::Uuid
}
