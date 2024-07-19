use diesel::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Queryable, Selectable, Serialize)]
#[diesel(table_name = crate::schema::toilet)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Toilets {
    pub id: uuid::Uuid,
    pub label: String,
    pub state: i32,
    pub coordinates: postgis_diesel::types::Point,
    pub idlock: Option<uuid::Uuid>,
    pub secret: Option<String>,
}

#[derive(Insertable, Deserialize, Serialize)]
#[diesel(table_name = crate::schema::toilet)]
pub struct NewToilets {
    pub label: String,
    pub state: i32,
    pub coordinates: postgis_diesel::types::Point,
    pub idlock: Option<uuid::Uuid>,
    pub secret: Option<String>,
}
