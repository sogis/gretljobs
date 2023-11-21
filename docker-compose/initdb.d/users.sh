#!/usr/bin/env bash

echo "Executing script 'users.sh'"


export PGPASSWORD=$POSTGRESQL_POSTGRES_PASSWORD

echo "ALTER USER :username CREATEROLE" | psql --variable=username=$POSTGRESQL_USERNAME

if [[ -n "${POSTGRESQL_USERNAME_2}" && -n "${POSTGRESQL_PASSWORD_2}" ]]; then
  echo "CREATE USER :username WITH PASSWORD :'password'" | psql --variable=username=$POSTGRESQL_USERNAME_2 --variable=password=$POSTGRESQL_PASSWORD_2
fi
