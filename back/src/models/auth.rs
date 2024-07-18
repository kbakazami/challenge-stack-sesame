use chrono::NaiveDate;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct AuthRole {
    pub role: i32
}

#[derive(Debug, Serialize, Deserialize)]
#[allow(non_snake_case)]
pub struct GoogleProfile {
    resourceName: String,
    etag: String,
    names: Vec<Name>,
    genders: Vec<Gender>,
    birthdays: Vec<Birthday>,
    emailAddresses: Vec<EmailAddress>,
}

#[derive(Debug, Serialize, Deserialize)]
#[allow(non_snake_case)]
struct Name {
    metadata: Metadata,
    displayName: String,
    familyName: String,
    givenName: Option<String>,
    displayNameLastFirst: String,
    unstructuredName: String,
}

#[derive(Debug, Serialize, Deserialize)]
#[allow(non_snake_case)]
struct Metadata {
    primary: bool,
    source: Source,
    sourcePrimary: Option<bool>, 
    verified: Option<bool>,      
}

#[derive(Debug, Serialize, Deserialize)]
struct Source {
    #[serde(rename = "type")]
    source_type: String,
    id: String,
}

#[derive(Debug, Serialize, Deserialize)]
#[allow(non_snake_case)]
struct Gender {
    metadata: Metadata,
    value: String,
    formattedValue: String,
}

#[derive(Debug, Serialize, Deserialize)]
struct Birthday {
    metadata: Metadata,
    date: Date,
}

#[derive(Debug, Serialize, Deserialize)]
struct Date {
    year: u16,
    month: u8,
    day: u8,
}

#[derive(Debug, Serialize, Deserialize)]
struct EmailAddress {
    metadata: Metadata,
    value: String,
}

impl GoogleProfile {
    
    pub fn get_gender(&self) -> i32 {
        match self.genders[0].value.as_str() {
            "female" => 1,
            "male" => 0,
            _ => 3
        }
    }

    pub fn get_birthdate(&self) -> Option<NaiveDate> {

        let year = self.birthdays[0].date.year as i32;
        let month = self.birthdays[0].date.month as u32;
        let day = self.birthdays[0].date.day as u32;

        NaiveDate::from_ymd_opt(year, month, day)
    }

    pub fn familly_name(&self) -> String {
        self.names[0].familyName.to_string()
    }

    pub fn first_name(&self) -> String {
        match self.names[0].givenName.clone() {
            Some(name) => name.clone(),
            None => String::new()
        }
    }

    pub fn get_email(&self) -> String {
        self.emailAddresses[0].value.clone()
    }
}