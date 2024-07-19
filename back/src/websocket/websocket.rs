use actix::prelude::*;
use actix_web::{web, HttpRequest, Responder};
use actix_web_actors::ws;
use serde::{Deserialize, Serialize};
use std::time::{Duration, Instant};
use uuid::Uuid;

#[derive(Message, Serialize, Deserialize)]
#[rtype(result = "()")]
struct Notification {
    message: String,
}

#[derive(Message)]
#[rtype(result = "()")]
struct WsMessage(pub String);

struct WsSession {
    hb: Instant,
    addr: Addr<NotificationServer>,
    lifetime: Duration,
}

impl Actor for WsSession {
    type Context = ws::WebsocketContext<Self>;

    fn started(&mut self, ctx: &mut Self::Context) {
        self.addr.do_send(Connect {
            addr: ctx.address(),
        });

        // Commencez le timer pour la durée de vie maximale
        ctx.run_later(self.lifetime, |_actor, ctx| {
            ctx.stop();
        });
    }

    fn stopped(&mut self, ctx: &mut Self::Context) {
        self.addr.do_send(Disconnect {
            addr: ctx.address(),
        });
    }
}

impl StreamHandler<Result<ws::Message, ws::ProtocolError>> for WsSession {
    fn handle(&mut self, msg: Result<ws::Message, ws::ProtocolError>, ctx: &mut Self::Context) {
        match msg {
            Ok(ws::Message::Ping(msg)) => {
                self.hb = Instant::now();
                ctx.pong(&msg);
            }
            Ok(ws::Message::Pong(_)) => {
                self.hb = Instant::now();
            }
            Ok(ws::Message::Text(text)) => {
                println!("Received message: {}", text);
                ctx.run_later(Duration::new(2, 0), |_, _| {
                    println!("2 seconds have passed since the first message was received.");
                });
            }
            _ => (),
        }
    }
}

impl Handler<WsMessage> for WsSession {
    type Result = ();

    fn handle(&mut self, msg: WsMessage, ctx: &mut Self::Context) {
        ctx.text(msg.0);
    }
}

#[derive(Message)]
#[rtype(result = "()")]
pub struct SendGlobalNotification {
    pub toilet_state: i32,
}
pub struct NotificationServer {
    sessions: Vec<Addr<WsSession>>,
}

#[derive(Serialize)]
struct ToiletNotification {
    toilet_state: i32,
}

impl NotificationServer {
    pub fn new() -> NotificationServer {
        NotificationServer {
            sessions: Vec::new(),
        }
    }

    fn send_global_notification(&self, toilet_state: i32) {
        for addr in &self.sessions {
            addr.do_send(WsMessage(toilet_state.to_string().clone()));
        }
    }
}

impl Handler<SendGlobalNotification> for NotificationServer {
    type Result = ();

    fn handle(&mut self, item: SendGlobalNotification, _: &mut Context<Self>) {
        self.send_global_notification(item.toilet_state);
    }
}

impl Actor for NotificationServer {
    type Context = Context<Self>;
}

struct Connect {
    addr: Addr<WsSession>,
}

impl Message for Connect {
    type Result = ();
}

impl Handler<Connect> for NotificationServer {
    type Result = ();

    fn handle(&mut self, msg: Connect, _: &mut Context<Self>) {
        self.sessions.push(msg.addr);
    }
}

struct Disconnect {
    addr: Addr<WsSession>,
}

impl Message for Disconnect {
    type Result = ();
}

impl Handler<Disconnect> for NotificationServer {
    type Result = ();

    fn handle(&mut self, msg: Disconnect, _: &mut Context<Self>) {
        self.sessions.retain(|a| a != &msg.addr);
    }
}

pub async fn ws_handler(
    req: HttpRequest,
    stream: web::Payload,
    data: web::Data<Addr<NotificationServer>>,
) -> impl Responder {
    let ws = WsSession {
        hb: Instant::now(),
        addr: data.get_ref().clone(),
        lifetime: Duration::from_secs(86400), // 1 jour
    };
    ws::start(ws, &req, stream)
}
