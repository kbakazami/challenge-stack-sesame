use actix_web::{web, HttpRequest, HttpResponse, Responder};
use diesel::{r2d2::ConnectionManager, PgConnection};
use r2d2::PooledConnection;

use crate::{models::feedback::NewFeedback, services::{feedback_services, users_services}, AppState};

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
    req: HttpRequest,
    state: web::Data<AppState>,
) -> impl Responder {

    let token = get_token(req).unwrap();

    match is_user_admin(token, state.get_conn()).await {
        Ok(_) => {
            match feedback_services::get_avg_score(state.get_conn()).await {
                Ok(vec_number) => HttpResponse::Ok().json(vec_number),
                Err(err) => {
                    HttpResponse::InternalServerError().body(format!("Failed to get scores: {}", err))
                }
            }
        }
        Err(err) => {
            err
        }
    }
}

fn get_token(req: HttpRequest) -> Result<String, HttpResponse> {
    let headers = req.headers();
    let token_authorization = headers.get(actix_web::http::header::AUTHORIZATION);
    match token_authorization {
        Some(access_token) => {
            Ok(access_token.to_str().unwrap().to_string())
        }
        None => {
            Err(HttpResponse::InternalServerError().body("No User info provided by google"))
        }
    }
}

async fn is_user_admin(
    access_token: String,
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
) -> Result<bool, HttpResponse> {
    let get_user_token = users_services::get_user_token(&mut conn, access_token).await;
    match get_user_token {
        Ok(user) => {
            if user.role_id == 1 || user.role_id == 3{
                return Ok(true);
            } else {
                return Err(HttpResponse::Unauthorized().body("You are not an admin"));
            }
        }
        Err(_) => {
            return Err(HttpResponse::InternalServerError().body("Error while getting user"));
        }
    }
}