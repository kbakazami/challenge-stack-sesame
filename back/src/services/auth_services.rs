
use crate::models::{auth::GoogleProfile, users::NewUsers};

pub async fn get_user_info(access_token: &str, role: i32) -> Result<NewUsers, reqwest::Error> {
    let user_url = "https://people.googleapis.com/v1/people/me?personFields=names,birthdays,genders,emailAddresses";
    
    let access_token_splitted = access_token.split_whitespace();
    let token = access_token_splitted.last().unwrap();

    let client = reqwest::Client::new();
    let response = client
        .get(user_url)
        .bearer_auth(token)
        .send()
        .await?;

    let user_info: GoogleProfile = response.json().await?;
    let last_name = user_info.familly_name();
    let first_name = user_info.first_name();
    let gender = user_info.get_gender();
    let date = user_info.get_birthdate().expect("Error no birthdate");
    let mail = user_info.get_email();

    Ok(NewUsers {
        civility: gender,
        email: mail.clone(),
        lastname: last_name.clone(),
        firstname: first_name,
        birthdate: date,
        token: Some(access_token.to_string()),
        role_id: role
    })  
}