use actix_web::{web, HttpResponse, Responder};

use crate::{models::{logs::NewLogs, toilet::NewToilets}, services::{stat_services, toilet_services, websocket_service::send_broadcast_message}, AppState};


pub async fn create_toilet(
    state: web::Data<AppState>,
    new_toilet: web::Json<NewToilets>,
) -> impl Responder {
    match toilet_services::create_toilet(state.get_conn(), new_toilet.into_inner()).await {
        Ok(inserted_toilet) => HttpResponse::Created().json(inserted_toilet),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to insert toilet: {}", err))
        }
    }
}

pub async fn get_toilets(state: web::Data<AppState>) -> impl Responder {
    match toilet_services::get_toilets(state.get_conn()).await {
        Ok(toilets) => HttpResponse::Ok().json(toilets),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to get toilets : {}", err))
        }
    }
}

pub async fn get_toilet(state: web::Data<AppState>, id: web::Path<uuid::Uuid>) -> impl Responder {
    match toilet_services::get_toilet(state.get_conn(), *id).await {
        Ok(toilet) => HttpResponse::Ok().json(toilet),
        Err(err) => HttpResponse::InternalServerError()
            .body(format!("Failed to get toilet {} : {}", id, err)),
    }
}

pub async fn open_toilet(
    state: web::Data<AppState>,
    toilet_id: web::Path<uuid::Uuid>,
) -> impl Responder {
    match toilet_services::open_toilet(state.get_conn(), *toilet_id).await {
        Ok(toilet) => {
            let new_log = NewLogs {
                type_: toilet.state,
                error: Some(String::from("Ouverture réussie")),
                toilet_id: *toilet_id,
            };

            match stat_services::create_log(state.get_conn(), new_log).await {
                Ok(inserted_log) => 
                {
                    send_broadcast_message(state.notification_server.clone(),(toilet.state));
                    HttpResponse::Created().json(inserted_log)
                }
                Err(err) => HttpResponse::InternalServerError().body(format!("Failed to insert logs: {}", err)),
            }
        }
        Err(err) => HttpResponse::InternalServerError().body(format!("Failed to open toilet: {}", err)),
    }
}

pub async fn close_toilet(
    state: web::Data<AppState>,
    toilet_id: web::Path<uuid::Uuid>,
) -> impl Responder {
    match toilet_services::close_toilet(state.get_conn(), *toilet_id).await {
        Ok(toilet) => {
            let new_log = NewLogs {
                type_: toilet.state,
                error: Some(String::from("Fermeture réussie")),
                toilet_id: *toilet_id,
            };

            match stat_services::create_log(state.get_conn(), new_log).await {
                Ok(inserted_log) => 
                {
                    send_broadcast_message(state.notification_server.clone(), toilet.state);
                    HttpResponse::Created().json(inserted_log)
                }                
                Err(err) => HttpResponse::InternalServerError().body(format!("Failed to insert logs: {}", err)),
            }
        }
        Err(err) => HttpResponse::InternalServerError().body(format!("Failed to open toilet: {}", err)),
    }
}

pub async fn delete_toilet(
    state: web::Data<AppState>,
    toilet_id: web::Path<uuid::Uuid>
) -> impl Responder {
    match toilet_services::delete_toilet(state.get_conn(), *toilet_id).await
    {
        Ok(toilet) => HttpResponse::Ok().json(toilet),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to delete toilet: {}", err))
        }
    }
}