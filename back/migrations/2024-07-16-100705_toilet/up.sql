CREATE TABLE toilet (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    label VARCHAR(30) NOT NULL,
    state INTEGER NOT NULL,
    coordinates geometry(POINT, 4326) NOT NULL,
    idLock uuid NULL,
    secret VARCHAR(255)
)