#!/bin/bash

sed -e "s/PG_USER/${POSTGRESQL_USERNAME}/g" -e "s/PG_DATABASE/${POSTGRESQL_DATABASE}/g" \
  /docker-entrypoint-preinitdb.d/setup.sql > /docker-entrypoint-initdb.d/setup.sql
