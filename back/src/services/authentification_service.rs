use oauth2::{basic::BasicClient, AuthUrl, ClientId, ClientSecret, RedirectUrl, TokenUrl};


pub async fn authentification_google(client_id: String, client_secret: String) {

    let redirect_url = "http://localhost:8000/api".to_string();

     let auth_url = AuthUrl::new("https://accounts.google.com/o/oauth2/v2/auth".to_string())
     .expect("Auth url not set up");
     let token_url = TokenUrl::new("https://www.googleapis.com/oauth2/v3/token".to_string())
        .expect("Invalid token endpoint URL");

    BasicClient::new(
        ClientId::new(client_id), 
        Some(ClientSecret::new(client_secret)), 
        auth_url, 
        Some(token_url)
    ).set_redirect_uri(RedirectUrl::new(redirect_url).unwrap());
}