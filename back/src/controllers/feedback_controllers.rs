use actix_web::{web, HttpResponse, Responder};

use crate::{models::feedback::NewFeedback, services::feedback_services, AppState};

pub async fn create_feedback(
    state: web::Data<AppState>,
    new_feedback: web::Json<NewFeedback>,
) -> impl Responder {
    match feedback_services::create_feedback(state.get_conn(), new_feedback.into_inner()).await {
        Ok(inserted_user) => HttpResponse::Created().json(inserted_user),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to insert feedback: {}", err))
        }
    }
}

pub async fn get_avg_score(
    state: web::Data<AppState>,
) -> impl Responder {
    match feedback_services::get_avg_score(state.get_conn()).await
    {
        Ok(vec_number) => HttpResponse::Ok().json(vec_number),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to get scores: {}", err))
        }
    }
}