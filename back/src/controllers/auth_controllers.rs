use actix_web::{web, HttpRequest, HttpResponse, Responder};

use crate::{models::auth::AuthRole, services::{auth_services, users_services}, AppState};

pub async fn verify(req: HttpRequest, data: web::Data<AppState>, query: web::Json<AuthRole>) -> impl Responder {
    let headers = req.headers();
    let token_authorization = headers.get(actix_web::http::header::AUTHORIZATION);

    match token_authorization {
        Some(token) => {
            let user_info = auth_services::get_user_info(token.to_str().unwrap(), query.role).await;
            match user_info {
                Ok(info) => {
                     let response = users_services::upsert_user(data.get_conn(), info.clone());
                     match response.await {
                         Ok(_) => HttpResponse::Ok().json(format!("{}", info.role_id)),
                         Err(_) => HttpResponse::InternalServerError().body("Error while creating user")
                     }
                }
                Err(err) => {
                    HttpResponse::InternalServerError().body(format!("Error: {:?}", err))
                }
            }
        }
        None => {
            HttpResponse::InternalServerError().body("No User info provided by google")
        }
    }

}
