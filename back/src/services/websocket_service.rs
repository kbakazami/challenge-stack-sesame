use actix::Addr;

use crate::websocket::websocket::{NotificationServer, SendGlobalNotification};

pub fn send_broadcast_message(server_addr: Addr<NotificationServer>, toilet_id:uuid::Uuid, toilet_state: i32) {
    server_addr.do_send(SendGlobalNotification {
        toilet_id,
        toilet_state,
    });
}