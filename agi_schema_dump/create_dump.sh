#!/bin/sh

PROPERTYFILE=/home/gradle/.gradle/gradle.properties

PGHOST=$1
PGDATABASE=$2
DBSCHEMAS=$3 # Example for providing multiple DB schema names: 'schema1 schema2 schema3 ...'

export PGHOST
export PGDATABASE
export PGUSER=`awk -F ' *[=|:] *' '$1 == "dbUserEditDdl" { print $2 }' ${PROPERTYFILE}`
export PGPASSWORD=`awk -F ' *[=|:] *' '$1 == "dbPwdEditDdl" { print $2 }' ${PROPERTYFILE}`

for DBSCHEMA in $DBSCHEMAS; do
    pg_dump -Fc -n $DBSCHEMA -f $DBSCHEMA.dump
done
