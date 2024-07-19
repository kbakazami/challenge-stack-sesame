# SESAME - Application

## Requirements
- Flutter : [Install](https://docs.flutter.dev/get-started/install)
- Docker: [Install](https://docs.docker.com/engine/install/)

## Create environment
Go to "back" directory

    cd back
Modify docker-compose.yaml (if necessery)

    environment:
	    POSTGRES_USER: myuser (db user)
	    POSTGRES_PASSWORD: mypassword (db password)
	    POSTGRES_DB: mydatabase (db name)
Create .env file

    DATABASE_URL=postgres://myuser:mypassword@postgres/mydatabase

Next use this command to create container

    docker compose up -d
Go to "front" directory

    cd ../front
 Create .env file

    CLIENT_ID=XXX
    CLIENT_SECRET=XXX

Install Flutter dependencies

    flutter pub get
