use actix_web::{HttpResponse, Responder};

use crate::services::hello_world_service;

pub async fn hello_world() -> impl Responder {
    HttpResponse::Ok().body(format!("{}", hello_world_service::hello_world()))
}