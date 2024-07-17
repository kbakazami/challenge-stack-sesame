use actix_web::{web, HttpResponse, Responder};

use crate::{services::role_services, AppState};

pub async fn get_roles(state: web::Data<AppState>) -> impl Responder {
    match role_services::get_roles(state.get_conn()).await {
        Ok(roles) => HttpResponse::Ok().json(roles),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to get roles : {}", err))
        }
    }
}
