CREATE TABLE access (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    api_key VARCHAR(255) NOT NULL,
    api_secret VARCHAR(255) NOT NULL,
    api_consumer VARCHAR(255) NOT NULL,
    creationDate TIMESTAMP default LOCALTIMESTAMP NOT NULL,
    active SMALLINT default 0 NOT NULL
)