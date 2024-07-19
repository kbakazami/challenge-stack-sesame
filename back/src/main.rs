use actix::{Actor, Addr};
use ::r2d2::PooledConnection;
use actix_cors::Cors;
use actix_web::{web, App, HttpServer};
use controllers::{feedback_controllers, role_controllers, stat_controllers, users_controllers,toilet_controllers};
use diesel::r2d2::{self, ConnectionManager};
use oauth2::{basic::BasicClient, AuthUrl, ClientId, ClientSecret, RedirectUrl, TokenUrl};
use r2d2::Pool;
use std::env;
use websocket::websocket::{ws_handler,NotificationServer};
use diesel::pg::PgConnection;

mod controllers;
mod middlewares;
mod models;
mod schema;
mod websocket;

#[derive(Clone)]
struct GoogleAuthConfig {
    client_id: String,
    client_secret: String,
}

#[derive(Clone)]
struct AppState {
    pub conn: Pool<ConnectionManager<PgConnection>>,
    oauth: oauth2::Client<
        oauth2::StandardErrorResponse<oauth2::basic::BasicErrorResponseType>,
        oauth2::StandardTokenResponse<oauth2::EmptyExtraTokenFields, oauth2::basic::BasicTokenType>,
        oauth2::basic::BasicTokenType,
        oauth2::StandardTokenIntrospectionResponse<
            oauth2::EmptyExtraTokenFields,
            oauth2::basic::BasicTokenType,
        >,
        oauth2::StandardRevocableToken,
        oauth2::StandardErrorResponse<oauth2::RevocationErrorResponseType>,
    >,
    pub notification_server: Addr<NotificationServer>,
}
impl AppState {

    pub fn get_conn(&self) -> PooledConnection<ConnectionManager<PgConnection>> {
        self.conn
            .get()
            .expect("Failed to get a connection from the pool.")
    }

}
mod services;

pub type PostgresPool = Pool<ConnectionManager<PgConnection>>;

fn get_pool() -> PostgresPool {
    dotenv::dotenv().ok();
    let url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    let mgr = ConnectionManager::<PgConnection>::new(url);
    r2d2::Pool::builder()
        .build(mgr)
        .expect("could not build connection pool")
}

fn get_googl_auth() -> GoogleAuthConfig {
    dotenv::dotenv().ok();
    let client_id = env::var("CLIENT_ID").expect("GOOGLE_CLIENT_ID must be set");
    let client_secret = env::var("CLIENT_SECRET").expect("GOOGLE_CLIENT_SECRET must be set");
    return GoogleAuthConfig {
        client_id,
        client_secret,
    };
}

fn build_oauth_client(google_auth: GoogleAuthConfig) -> BasicClient {
    let redirect_url = "http://localhost:8080/api/auth/google_callback".to_string();

    let auth_url = AuthUrl::new("https://accounts.google.com/o/oauth2/v2/auth".to_string())
        .expect("Auth url not set up");
    let token_url = TokenUrl::new("https://www.googleapis.com/oauth2/v3/token".to_string())
        .expect("Invalid token endpoint URL");

    return BasicClient::new(
        ClientId::new(google_auth.client_id),
        Some(ClientSecret::new(google_auth.client_secret)),
        auth_url,
        Some(token_url),
    )
    .set_redirect_uri(RedirectUrl::new(redirect_url).unwrap());
}

fn logging_setup() {
    std::env::set_var("RUST_LOG", "debug");
    env_logger::init();
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    logging_setup();
    let notification_server: Addr<NotificationServer> = NotificationServer::new().start();
    let pool = get_pool();
    let client = build_oauth_client(get_googl_auth());
    let state = AppState {
        conn: pool,
        oauth: client,
        notification_server: notification_server.clone(),

    };


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
            .app_data(web::Data::new(notification_server.clone()))
            .service(
                web::scope("/api")
                    .service(
                        web::scope("/auth")
                            .route(
                                "/login",
                                web::get().to(controllers::auth_controllers::login),
                            )
                            .route(
                                "/google_callback",
                                web::get().to(controllers::auth_controllers::googlecallback),
                            ),
                    )
                    .service(
                        web::scope("/stats")
                            //.wrap(middlewares::auth_middleware::AuthMiddleware)
                            .route("/new", web::post().to(stat_controllers::create_log))
                            .route(
                                "/get_nb_passage",
                                web::get().to(stat_controllers::get_log_nb_passage),
                            )
                            .route(
                                "/get_affluence",
                                web::get().to(stat_controllers::get_affluence),
                            ),
                    )
                    .service(
                        web::scope("/users")
                            //.wrap(middlewares::auth_middleware::AuthMiddleware)
                            .route("/new", web::post().to(users_controllers::create_user))
                            .route("/{id}", web::delete().to(users_controllers::delete_user))
                            .route("/{id}", web::get().to(users_controllers::get_user))
                            .route("", web::get().to(users_controllers::get_users))
                            .route(
                                "/proportion",
                                web::get().to(users_controllers::get_proportion),
                            ),
                    )
                    .service(
                        web::scope("/toilets")
                            //.wrap(middlewares::auth_middleware::AuthMiddleware)
                            .route("/", web::get().to(toilet_controllers::get_toilets))
                            .route("/{id}", web::get().to(toilet_controllers::get_toilet))
                            .route("/new", web::post().to(toilet_controllers::create_toilet))
                            .route("/{id}/open", web::put().to(toilet_controllers::open_toilet))
                            .route("/{id}/close",web::put().to(toilet_controllers::close_toilet))
                            .route("/{id}/delete", web::delete().to(toilet_controllers::delete_toilet))
                    )
                    .service(
                        web::scope("/role")
                            //.wrap(middlewares::auth_middleware::AuthMiddleware)
                            .route("", web::get().to(role_controllers::get_roles)),
                    )
                    .service(
                        web::scope("/feedback")
                            //.wrap(middlewares::auth_middleware::AuthMiddleware)
                            .route(
                                "/new",
                                web::post().to(feedback_controllers::create_feedback),
                            )
                            .route(
                                "/avg_score",
                                web::get().to(feedback_controllers::get_avg_score),
                            ),
                    ),
            )
            .route("/ws", web::get().to(ws_handler))
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
