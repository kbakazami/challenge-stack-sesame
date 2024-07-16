use diesel::prelude::*;
use serde::{Deserialize, Serialize};

#[derive(Queryable, Selectable, Serialize)]
#[diesel(table_name = crate::schema::role)]
#[diesel(check_for_backend(diesel::pg::Pg))]
pub struct Role {
    pub id: i32,
    pub label: String,
}

#[derive(Insertable, Deserialize, Serialize)]
#[diesel(table_name = crate::schema::role)]
pub struct NewRole {
    pub label: String
}
