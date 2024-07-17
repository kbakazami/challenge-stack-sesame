use actix_session::Session;
use actix_web::{web, HttpResponse, Responder};
use oauth2::{AuthorizationCode, CsrfToken};
use serde::Deserialize;
use crate::{AppState};

#[derive(Deserialize)]
pub struct AuthRequest {
    code: String,
    state: String,
    scope: String,
}

pub async fn googlecallback(session: Session,data: web::Data<AppState>, params: web::Query<AuthRequest>) -> impl Responder {
    let code = AuthorizationCode::new(params.code.clone());
    let state = CsrfToken::new(params.state.clone());
    let _scope = params.scope.clone();

    // Exchange the code with a token.
    let token = &data.oauth.exchange_code(code);

    HttpResponse::Ok().json(token.)
}