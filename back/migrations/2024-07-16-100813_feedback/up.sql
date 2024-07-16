CREATE TABLE feedback(
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    comment text NULL,
    score INTEGER NOT NULL,
    creationDate TIMESTAMP default LOCALTIMESTAMP NOT NULL
)