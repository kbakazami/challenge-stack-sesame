use diesel::{prelude::*, r2d2::ConnectionManager, result::Error};
use r2d2::PooledConnection;
use rand::Rng;

use crate::{
    models::{
        toilet::{NewToilets, Toilets},
        toiletStatus::ToiletStatus,
    },
    schema::toilet::{dsl::toilet, id, state},
};

pub async fn create_toilet(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    new_toilet: NewToilets,
) -> Result<Toilets, Error> {
    let new_toilet = NewToilets {
        label: new_toilet.label,
        state: new_toilet.state,
        coordinates: new_toilet.coordinates,
        idlock: new_toilet.idlock,
        secret: new_toilet.secret,
    };
    diesel::insert_into(toilet)
        .values(new_toilet)
        .get_result::<Toilets>(&mut conn)
}

pub async fn get_toilets(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
) -> Result<Vec<Toilets>, Error> {
    let result = match toilet.load::<Toilets>(&mut conn) {
        Ok(items) => items.iter().map(|item|{

        
            let random_state = rand::thread_rng().gen_range(1..=4);

        Toilets{
            
            id : item.id,
            label : item.label.clone(),
            state : random_state,
            coordinates : item.coordinates,
            idlock : item.idlock,
            secret : item.secret.clone(),
        }}).collect::<Vec<Toilets>>(),
        
        Err(err) => {
            return Err(err)
        }
    
    };
    Ok(result)
}

pub async fn get_toilet(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    toilet_id: uuid::Uuid,
) -> Result<Toilets, Error> {
    match toilet
        .filter(id.eq(toilet_id))
        .get_result::<Toilets>(&mut conn)
    {
        Ok(item) => Ok(item),
        Err(err) => return Err(err),
    }
}

pub async fn update_toilet_state(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    toilet_state: i32,
    toilet_id: uuid::Uuid,
) -> Result<Toilets, Error> {
    diesel::update(toilet.find(toilet_id))
        .set((state.eq(toilet_state),))
        .get_result::<Toilets>(&mut conn)
}

pub async fn delete_toilet(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    toilet_id: uuid::Uuid,
) -> Result<Toilets, Error>{
    diesel::delete(toilet.find(toilet_id))
    .get_result(&mut conn)
}

pub async fn open_toilet(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    toilet_id: uuid::Uuid,
) -> Result<Toilets, Error> {
    let current_toilet = toilet.filter(id.eq(toilet_id)).first::<Toilets>(&mut conn);

    let toilet_state = current_toilet.unwrap().state;
    match toilet_state {
        1 => update_toilet_state(conn, ToiletStatus::Free.id(), toilet_id).await,
        2 => update_toilet_state(conn, ToiletStatus::Opening.id(), toilet_id).await,
        
        _ => {
            panic!("Les toilettes ne sont pas disponible");
        }
    }
}

pub async fn close_toilet(
    mut conn: PooledConnection<ConnectionManager<PgConnection>>,
    toilet_id: uuid::Uuid,
) -> Result<Toilets, Error> {
    let current_toilet = toilet.filter(id.eq(toilet_id)).first::<Toilets>(&mut conn);

    let toilet_state = current_toilet.unwrap().state;
    match toilet_state {
        5 => update_toilet_state(conn, ToiletStatus::Used.id(), toilet_id).await,

        _ => {
            panic!("Les toilettes ne sont pas libres");
        }
    }
}
