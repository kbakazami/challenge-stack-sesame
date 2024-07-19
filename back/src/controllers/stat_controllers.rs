use actix_web::{web, HttpRequest, HttpResponse, Responder};

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
    req: HttpRequest,
    state: web::Data<AppState>,
) -> impl Responder {

    let token = get_splitted_token(req).unwrap();

    match stat_services::get_log_nb_passage(token, state.get_conn()).await
    {
        Ok(vec_number) => HttpResponse::Ok().json(vec_number),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to get logs: {}", err))
        }
    }
}

pub async fn get_affluence(
    req: HttpRequest,
    state: web::Data<AppState>,
) -> impl Responder {

    let token = get_splitted_token(req).unwrap();


    match stat_services::get_affluence(token,state.get_conn()).await
    {
        Ok(vec_number) => HttpResponse::Ok().json(vec_number),
        Err(err) => {
            HttpResponse::InternalServerError().body(format!("Failed to get affluence: {}", err))
        }
    }
}

fn get_splitted_token(req: HttpRequest) -> Result<String, HttpResponse> {
    let headers = req.headers();
    let token_authorization = headers.get(actix_web::http::header::AUTHORIZATION);
    match token_authorization {
        Some(access_token) => {
            let access_token_splitted = access_token.to_str().unwrap().split_whitespace();
            Ok(access_token_splitted.last().unwrap().to_string())
        }
        None => {
            Err(HttpResponse::InternalServerError().body("No User info provided by google"))
        }
    }
}