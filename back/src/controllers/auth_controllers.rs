use actix_web::{web, HttpResponse, Responder};
use oauth2::{reqwest::async_http_client, AuthorizationCode, CsrfToken, Scope, TokenResponse};

use crate::{models::auth::AuthRequest, AppState};

pub async fn googlecallback(data: web::Data<AppState>, params: web::Query<AuthRequest>)  -> impl Responder {
    let client = &data.oauth;
    let test = 0;
    let token_result = client.exchange_code(AuthorizationCode::new(params.code.clone()))
        .request_async(async_http_client)
        .await;

    match token_result {
        Ok(token) => HttpResponse::Ok().json(token.access_token()),
        Err(err) => HttpResponse::InternalServerError().body(format!("Error: {:?}", err)),
    }
}

pub async fn login(data: web::Data<AppState>) -> impl Responder {
    let (authorize_url, _csrf_token) = data.oauth
        .authorize_url(CsrfToken::new_random)
        .add_scope(Scope::new("profile".to_string()))
        .add_scope(Scope::new("email".to_string()))
        .url();

    HttpResponse::Found()
        .append_header(("Location", authorize_url.to_string()))
        .finish()
}
