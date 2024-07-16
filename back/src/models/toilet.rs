use diesel::prelude::*;
use postgis_diesel::types::*;
use serde::{Deserialize, Serialize};

#[derive(Queryable, Selectable, Serialize)]
#[diesel(table_name = crate::schema::toilet)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Toilets {
    pub id: uuid::Uuid,
    pub label: String,
    pub state: i32,
    pub coordinates: Point,
    pub idlock: Option<uuid::Uuid>,
}

#[derive(Insertable, Deserialize, Serialize)]
#[diesel(table_name = crate::schema::toilet)]
pub struct NewToilets {
    pub label: String,
    pub state: i32,
    pub coordinates: Point,
    pub idlock: Option<uuid::Uuid>,
}
