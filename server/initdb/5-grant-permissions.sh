#!/bin/bash
set -e

echo "Granting permissions"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  -- Grant limited permissions to anonymous user
  GRANT USAGE ON SCHEMA public, auth, jwt, pgcrypto TO ${PGRST_DB_ANON_ROLE};

  GRANT SELECT ON ALL TABLES IN SCHEMA public TO ${PGRST_DB_ANON_ROLE};
  GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO ${PGRST_DB_ANON_ROLE};
  GRANT SELECT ON ALL TABLES IN SCHEMA auth TO ${PGRST_DB_ANON_ROLE};

  -- Grant wider permissions to logged user
  GRANT USAGE ON SCHEMA public, auth, jwt, pgcrypto TO ${PGRST_DB_WEB_ROLE};

  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${PGRST_DB_WEB_ROLE};
  GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ${PGRST_DB_WEB_ROLE};
  GRANT SELECT ON ALL TABLES IN SCHEMA auth TO ${PGRST_DB_WEB_ROLE};

  -- Allow authenticator to become anonymous or logged user
  GRANT ${PGRST_DB_WEB_ROLE} TO ${PGRST_DB_AUTH_USER};
  GRANT ${PGRST_DB_ANON_ROLE} TO ${PGRST_DB_AUTH_USER};
EOSQL
