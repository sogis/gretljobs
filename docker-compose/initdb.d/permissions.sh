#!/bin/bash

echo "Executing script 'permissions.sh'"


export PGPASSWORD=$POSTGRESQL_POSTGRES_PASSWORD

echo "REVOKE TEMPORARY ON DATABASE :database FROM PUBLIC" | psql --variable=database=$POSTGRESQL_DATABASE

echo "REVOKE CREATE ON SCHEMA public FROM PUBLIC" | psql --dbname $POSTGRESQL_DATABASE
