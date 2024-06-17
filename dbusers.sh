#!/bin/bash

set -e

# Create additional DB user with DDL and CREATEROLE privileges
if [[ -n "${POSTGRESQL_USERNAME}" && -n "${POSTGRESQL_PASSWORD}" ]]; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
    --variable=username=$POSTGRESQL_USERNAME \
    --variable=password=$POSTGRESQL_PASSWORD \
    --variable=database=$POSTGRES_DB \
    <<-EOSQL
    CREATE USER :"username" WITH PASSWORD :'password';
    GRANT ALL PRIVILEGES ON DATABASE :"database" TO :"username";
    ALTER USER :"username" CREATEROLE;
EOSQL
fi

# Create additional DB user without any privileges
if [[ -n "${POSTGRESQL_USERNAME_2}" && -n "${POSTGRESQL_PASSWORD_2}" ]]; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
    --variable=username=$POSTGRESQL_USERNAME_2 \
    --variable=password=$POSTGRESQL_PASSWORD_2 \
    <<-EOSQL
    CREATE USER :"username" WITH PASSWORD :'password';
EOSQL
fi
