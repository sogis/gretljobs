#!/bin/sh

PROPERTYFILE=/home/gradle/.gradle/gradle.properties

PGHOST=$1
PGDATABASE=$2
DBSCHEMANAME=$3

export PGHOST
export PGDATABASE
export PGUSER=`awk -F ' *[=|:] *' '$1 == "dbUserEdit" { print $2 }' ${PROPERTYFILE}`
export PGPASSWORD=`awk -F ' *[=|:] *' '$1 == "dbPwdEdit" { print $2 }' ${PROPERTYFILE}`

pg_dump -Fc -n ${DBSCHEMANAME} -f schema.dump