use actix_cors::Cors;
use actix_web::{web, App, HttpServer};
use controllers::hello_world_controllers::hello_world;
use oauth2::{basic::BasicClient, AuthUrl, ClientId, ClientSecret, RedirectUrl, TokenUrl};
use diesel::prelude::*;
use diesel::r2d2::{self, ConnectionManager};
use r2d2::Pool;
use std::env;

mod services;
mod controllers;
mod models;
mod schema;

#[derive(Clone)]
struct GoogleAuth {
    client_id: String,
    client_secret: String,
}

#[derive(Clone)]
struct AppState {
    conn: Pool<ConnectionManager<PgConnection>>,
    oauth: BasicClient,
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

fn get_googl_auth() -> GoogleAuth {
    dotenv::dotenv().ok();
    let client_id = env::var("CLIENT_ID").expect("GOOGLE_CLIENT_ID must be set");
    let client_secret = env::var("CLIENT_SECRET").expect("GOOGLE_CLIENT_SECRET must be set");
    return GoogleAuth {
        client_id,
        client_secret,
    }
}

pub fn build_oauth_client(google_auth: GoogleAuth) -> BasicClient {

    let redirect_url = "http://localhost:8000/api".to_string();

     let auth_url = AuthUrl::new("https://accounts.google.com/o/oauth2/v2/auth".to_string())
     .expect("Auth url not set up");
     let token_url = TokenUrl::new("https://www.googleapis.com/oauth2/v3/token".to_string())
        .expect("Invalid token endpoint URL");

    return BasicClient::new(
        ClientId::new(google_auth.client_id), 
        Some(ClientSecret::new(google_auth.client_secret)), 
        auth_url, 
        Some(token_url)
    ).set_redirect_uri(RedirectUrl::new(redirect_url).unwrap());
}

fn logging_setup() {
    std::env::set_var("RUST_LOG", "debug");
    env_logger::init();
}

#[actix_web::main]
async fn main() -> std::io::Result<()>{
    logging_setup();
    let pool = get_pool();
    let client = build_oauth_client(get_googl_auth());
    let state = AppState { conn: pool, oauth: client};
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
    .route("", web::get().to(hello_world))
    .service(web::scope("/api")
        .service(web::scope("/auth"))
        .route("/google_callback", web::get().to(controllers::auth_controllers::googlecallback))
)
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
