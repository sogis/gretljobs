#!/bin/bash

echo "Executing script 'postgresql_config.sh'"
cp /docker-entrypoint-preinitdb.d/custom.conf /opt/bitnami/postgresql/conf/conf.d/
