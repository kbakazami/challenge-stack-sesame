use actix_cors::Cors;
use actix_web::{web, App, HttpServer};
use controllers::hello_world_controllers::hello_world;
use diesel::prelude::*;
use diesel::r2d2::{self, ConnectionManager};
use r2d2::Pool;
use std::env;

mod services;
mod controllers;
mod models;

#[derive(Clone)]
struct AppState {
    conn: Pool<ConnectionManager<PgConnection>>,
}

pub type PostgresPool = Pool<ConnectionManager<PgConnection>>;

fn get_pool() -> PostgresPool {
    dotenv::dotenv().ok();
    let url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    let mgr = ConnectionManager::<PgConnection>::new(url);
    r2d2::Pool::builder()
        .build(mgr)
        .expect("could not build connection pool")
}

fn logging_setup() {
    std::env::set_var("RUST_LOG", "debug");
    env_logger::init();
}

#[actix_web::main]
async fn main() -> std::io::Result<()>{
    logging_setup();
    let pool = get_pool();
    let state = AppState { conn: pool };
    println!("Welcome to Rust Server! ");
    HttpServer::new(move || {
        let cors = Cors::default()
        .allow_any_origin()
        .allow_any_method()
        .allow_any_header()
        .max_age(3600);
    App::new()
    .wrap(cors)
    .app_data(web::Data::new(state.clone())) 
    .service(web::scope("/api")
        .route("", web::get().to(hello_world))
)
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
