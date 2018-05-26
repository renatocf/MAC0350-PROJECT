-- Load extension that allows criptography. More info at:
-- https://www.postgresql.org/docs/10/static/pgcrypto.html
CREATE SCHEMA pgcrypto;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA pgcrypto;
