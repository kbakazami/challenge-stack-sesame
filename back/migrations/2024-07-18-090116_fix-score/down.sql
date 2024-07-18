-- This file should undo anything in `up.sql`
ALTER TABLE feedback 
ALTER COLUMN score TYPE integer;