use ::r2d2::PooledConnection;
use actix_cors::Cors;
use actix_web::{web, App, Error, HttpRequest, HttpResponse, HttpServer};
use actix_web_actors::ws;
use controllers::{feedback_controllers, role_controllers, stat_controllers, users_controllers,toilet_controllers};
use diesel::prelude::*;
use diesel::r2d2::{self, ConnectionManager};
use r2d2::Pool;
use std::env;
use websocket::websocket::MyWebSocket;
mod controllers;
mod middlewares;
mod models;
mod schema;
mod websocket;

/// WebSocket handshake and start `MyWebSocket` actor.
async fn echo_ws(req: HttpRequest, stream: web::Payload) -> Result<HttpResponse, Error> {
    ws::start(MyWebSocket::new(), &req, stream)
}

#[derive(Clone)]
struct AppState {
    pub conn: Pool<ConnectionManager<PgConnection>>
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

fn logging_setup() {
    std::env::set_var("RUST_LOG", "debug");
    env_logger::init();
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    logging_setup();

    let pool = get_pool();
    let state = AppState {
        conn: pool
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
                            .wrap(middlewares::auth_middleware::AuthMiddleware)
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
                            .wrap(middlewares::auth_middleware::AuthMiddleware)
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
                            .wrap(middlewares::auth_middleware::AuthMiddleware)
                            .route("/", web::get().to(toilet_controllers::get_toilets))
                            .route("/{id}", web::get().to(toilet_controllers::get_toilet))
                            .route("/new", web::post().to(toilet_controllers::create_toilet))
                            .route("/{id}/open", web::put().to(toilet_controllers::open_toilet))
                            .route("/{id}/close",web::put().to(toilet_controllers::close_toilet))
                            .route("/{id}/delete", web::delete().to(toilet_controllers::delete_toilet))
                    )
                    .service(
                        web::scope("/role")
                            .wrap(middlewares::auth_middleware::AuthMiddleware)
                            .route("", web::get().to(role_controllers::get_roles)),
                    )
                    .service(
                        web::scope("/feedback")
                            .wrap(middlewares::auth_middleware::AuthMiddleware)
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
            .service(web::scope("/ws").route("", web::get().to(echo_ws)))
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
