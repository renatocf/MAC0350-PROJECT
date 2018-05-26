#!/bin/bash
set -e

echo "Configuring database"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  -- Create anon and authenticator users
  -- http://postgrest.org/en/v4.4/tutorials/tut0.html?highlight=anon#step-4-create-database-for-api
  CREATE ROLE ${PGRST_DB_AUTH_USER}
         PASSWORD '${PGRST_DB_AUTH_PASSWORD}'
         LOGIN NOINHERIT;

  CREATE ROLE ${PGRST_DB_ANON_ROLE} NOLOGIN NOINHERIT;
  CREATE ROLE ${PGRST_DB_WEB_ROLE} NOLOGIN NOINHERIT;
EOSQL
