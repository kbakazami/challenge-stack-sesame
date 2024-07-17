use actix_web::{web, HttpResponse, Responder};

use crate::{models::users::NewUsers, services::users_services, AppState};

pub async fn create_user(
    state: web::Data<AppState>,
    new_user: web::Json<NewUsers>,
) -> impl Responder {
    match users_services::create_user(state.get_conn(), new_user.into_inner()).await
    {
        Ok(inserted_user) => HttpResponse::Created().json(inserted_user),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to insert user: {}", err))
        }
    }
}

pub async fn get_user(
    state: web::Data<AppState>,
    id: web::Path<uuid::Uuid>
) -> impl Responder {
    match users_services::get_user(state.get_conn(), *id).await
    {
        Ok(fetched_user) => HttpResponse::Ok().json(fetched_user),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to get user {} : {}", id, err))
        }
    }
}
