#!/bin/sh

PROPERTYFILE=/home/gradle/.gradle/gradle.properties

DBNAME=$1
DBSCHEMAS=$2 # Example for providing multiple DB schema names: 'schema1 schema2 schema3 ...'

export PGHOST=`echo $ORG_GRADLE_PROJECT_dbUriEdit | awk -F '/' '{ print $3 }'`
export PGUSER=`awk -F ' *[=|:] *' '$1 == "dbUserEditDdl" { print $2 }' ${PROPERTYFILE}`
export PGPASSWORD=`awk -F ' *[=|:] *' '$1 == "dbPwdEditDdl" { print $2 }' ${PROPERTYFILE}`

for DBSCHEMA in $DBSCHEMAS; do
    pg_dump -Fc -n $DBSCHEMA -f $DBSCHEMA.dump $DBNAME
done
