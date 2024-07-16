CREATE TABLE users (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    civility INTEGER default 0 NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    firstname VARCHAR(50) NOT NULL,
    birthdate date NOT NULL,
    email VARCHAR(150) NOT NULL,
    token VARCHAR(255) NULL
)