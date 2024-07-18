use actix_web::{web, HttpResponse, Responder};

use crate::{models::users::NewUsers, services::users_services, AppState};

pub async fn create_user(
    state: web::Data<AppState>,
    new_user: web::Json<NewUsers>,
) -> impl Responder {
    match users_services::create_user(state.get_conn(), new_user.into_inner()).await {
        Ok(inserted_user) => HttpResponse::Created().json(inserted_user),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to insert user: {}", err))
        }
    }
}

pub async fn delete_user(state: web::Data<AppState>, id: web::Path<uuid::Uuid>) -> impl Responder {
    match users_services::delete_user(state.get_conn(), *id).await {
        Ok(_) => HttpResponse::Created().body(format!("User deleted !")),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to insert user: {}", err))
        }
    }
}

pub async fn get_user(state: web::Data<AppState>, id: web::Path<uuid::Uuid>) -> impl Responder {
    match users_services::get_user(state.get_conn(), *id).await {
        Ok(fetched_user) => HttpResponse::Ok().json(fetched_user),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to get user {} : {}", id, err))
        }
    }
}

pub async fn get_users(state: web::Data<AppState>) -> impl Responder {
    match users_services::get_users(state.get_conn()).await {
        Ok(fetched_users) => HttpResponse::Ok().json(fetched_users),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to get users : {}", err))
        }
    }
}

pub async fn get_proportion(state: web::Data<AppState>) -> impl Responder {
    match users_services::get_proportion(state.get_conn()).await {
        Ok(fetched_users) => HttpResponse::Ok().json(fetched_users),
        Err(err) => HttpResponse::InternalServerError()
            .body(format!("Failed to get proportion users : {}", err)),
    }
}
