// @generated automatically by Diesel CLI.

pub mod sql_types {
}

diesel::table! {
    use diesel::sql_types::*;
    use postgis_diesel::sql_types::*;

    access (id) {
        id -> Uuid,
        #[max_length = 255]
        api_key -> Varchar,
        #[max_length = 255]
        api_secret -> Varchar,
        #[max_length = 255]
        api_consumer -> Varchar,
        creationdate -> Timestamp,
        active -> Int2,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use postgis_diesel::sql_types::*;

    feedback (id) {
        id -> Uuid,
        #[max_length = 100]
        title -> Varchar,
        comment -> Nullable<Text>,
        score -> Int4,
        creationdate -> Timestamp,
        user_id -> Uuid,
        toilet_id -> Uuid,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use postgis_diesel::sql_types::*;

    logs (id) {
        id -> Int4,
        #[sql_name = "type"]
        type_ -> Int4,
        error -> Nullable<Text>,
        creationdate -> Timestamp,
        toilet_id -> Uuid,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use postgis_diesel::sql_types::*;

    role (id) {
        id -> Int4,
        #[max_length = 50]
        label -> Varchar,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use postgis_diesel::sql_types::*;

    spatial_ref_sys (srid) {
        srid -> Int4,
        #[max_length = 256]
        auth_name -> Nullable<Varchar>,
        auth_srid -> Nullable<Int4>,
        #[max_length = 2048]
        srtext -> Nullable<Varchar>,
        #[max_length = 2048]
        proj4text -> Nullable<Varchar>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use postgis_diesel::sql_types::*;

    toilet (id) {
        id -> Uuid,
        #[max_length = 30]
        label -> Varchar,
        state -> Int4,
        coordinates -> Geometry,
        idlock -> Nullable<Uuid>,
        #[max_length = 255]
        secret -> Nullable<Varchar>,
    }
}

diesel::table! {
    use diesel::sql_types::*;
    use postgis_diesel::sql_types::*;

    users (id) {
        id -> Uuid,
        civility -> Int4,
        #[max_length = 50]
        lastname -> Varchar,
        #[max_length = 50]
        firstname -> Varchar,
        birthdate -> Date,
        #[max_length = 150]
        email -> Varchar,
        #[max_length = 255]
        token -> Nullable<Varchar>,
        role_id -> Int4,
    }
}

diesel::joinable!(feedback -> toilet (toilet_id));
diesel::joinable!(feedback -> users (user_id));
diesel::joinable!(logs -> toilet (toilet_id));
diesel::joinable!(users -> role (role_id));

diesel::allow_tables_to_appear_in_same_query!(
    access,
    feedback,
    logs,
    role,
    spatial_ref_sys,
    toilet,
    users,
);
