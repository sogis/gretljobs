# agi_dm01avso24

GRETL-Job für Bulk-Import der AV-Daten.

Der AV-Import wird mit Apache Camel gemacht. Der Download und die Transformation nach ITF-CH und DXF-Geobau ist laufend, der Import in die Datenbank dreimal täglich. Wenn z.B. das Schema neu aufgesetzt wird, müssen sämtliche Gemeinden möglichst schnell importiert werden. Dazu dient dieser GRETL-Job. Die Daten werden von S3 heruntergeladen.

## Developing

```
docker run --rm --name edit-db -p 54321:5432 --hostname primary \
-e PG_DATABASE=edit -e PG_PRIMARY_PORT=5432 -e PG_MODE=primary \
-e PG_USER=admin -e PG_PASSWORD=admin \
-e PG_PRIMARY_USER=repl -e PG_PRIMARY_PASSWORD=repl \
-e PG_ROOT_PASSWORD=secret \
-e PG_WRITE_USER=gretl -e PG_WRITE_PASSWORD=gretl \
-e PG_READ_USER=ogc_server -e PG_READ_PASSWORD=ogc_server \
-v /tmp:/pgdata \
sogis/oereb-db
```

```
java -jar /Users/stefan/apps/ili2pg-4.3.1/ili2pg-4.3.1.jar \
--dbschema agi_dm01avso24 --models DM01AVSO24LV95 \
--defaultSrsCode 2056 --createGeomIdx --createFk --createFkIdx --createEnumTabs --beautifyEnumDispName --createMetaInfo --createNumChecks --nameByTopic --strokeArcs \
--createBasketCol --createDatasetCol --createImportTabs --createscript agi_dm01avso24.sql
```

```
export ORG_GRADLE_PROJECT_dbUriEdit="jdbc:postgresql://host.docker.internal:54321/edit"
export ORG_GRADLE_PROJECT_dbUserEdit="gretl"
export ORG_GRADLE_PROJECT_dbPwdEdit="gretl"
```

```
scripts/start-gretl.sh --docker-image sogis/gretl-runtime:latest --job-directory agi_dm01avso24/ tasks --all
```
