#!/bin/bash
set -e

echo "Injecting credentials"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  -- Grant limited permissions to anonymous user
  ALTER DATABASE dbz SET "app.settings.jwt_secret" TO '${PGRST_JWT_SECRET}';

  ALTER DATABASE dbz SET "app.settings.web_role" TO '${PGRST_DB_WEB_ROLE}';
  ALTER DATABASE dbz SET "app.settings.anon_role" TO '${PGRST_DB_ANON_ROLE}';
EOSQL

