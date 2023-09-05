#!/bin/bash

echo "Executing script 'users.sh'"


export PGPASSWORD=$POSTGRESQL_POSTGRES_PASSWORD

echo "ALTER USER :username CREATEROLE" | psql --variable=username=$POSTGRESQL_USERNAME

echo "CREATE USER dmluser WITH PASSWORD 'dmluser'" | psql
