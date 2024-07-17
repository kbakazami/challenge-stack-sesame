-- This file should undo anything in `up.sql`
delete from role where label = 'client';
delete from role where label = 'user';
delete from role where label = 'admin';