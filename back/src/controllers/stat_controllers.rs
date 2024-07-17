use actix_web::{web, HttpResponse, Responder};

use crate::{models::logs::NewLogs, services::stat_services, AppState};

pub async fn create_log(
    state: web::Data<AppState>,
    new_log: web::Json<NewLogs>,
) -> impl Responder {
    match stat_services::create_log(state.get_conn(), new_log.into_inner()).await
    {
        Ok(inserted_log) => HttpResponse::Created().json(inserted_log),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to insert logs: {}", err))
        }
    }
}

pub async fn get_log_nb_passage(
    state: web::Data<AppState>,
) -> impl Responder {
    match stat_services::get_log_nb_passage(state.get_conn()).await
    {
        Ok(vec_number) => HttpResponse::Ok().json(vec_number),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to get logs: {}", err))
        }
    }
}
