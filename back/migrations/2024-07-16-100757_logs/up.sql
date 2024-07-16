CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    type INTEGER NOT NULL,
    error text NULL,
    creationDate TIMESTAMP default LOCALTIMESTAMP NOT NULL
)