-- Your SQL goes here
ALTER TABLE logs
    ADD COLUMN toilet_id uuid REFERENCES toilet(id) NOT NULL;

ALTER TABLE feedback
    ADD COLUMN user_id uuid REFERENCES users(id) NOT NULL,
    ADD COLUMN toilet_id uuid REFERENCES toilet(id) NOT NULL;

ALTER TABLE users
    ADD COLUMN role_id INTEGER REFERENCES role(id) NOT NULL;