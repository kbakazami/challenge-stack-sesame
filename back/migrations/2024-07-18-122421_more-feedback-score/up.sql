-- Your SQL goes here
ALTER TABLE feedback
ADD COLUMN score_clean real NULL;

ALTER TABLE feedback
ADD COLUMN score_time real NULL;

ALTER TABLE feedback
ADD COLUMN score_global real NULL;
