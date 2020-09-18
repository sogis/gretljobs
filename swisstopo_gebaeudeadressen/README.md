```
scp bjsvwzie@geoutil.verw.rootso.org:/opt/workspace/dbdump/globals_geodb.rootso.org.dmp /tmp
sed -E -i.bak '/^CREATE ROLE (postgres|admin|gretl)\;/d; /^ALTER ROLE (postgres|admin|gretl) /d' /tmp/globals_geodb.rootso.org.dmp


docker cp /tmp/globals_geodb.rootso.org.dmp gretljobs-swisstopo-gebaeudeadressen_pub-db_1:/tmp
docker exec -e PGHOST=/tmp -it gretljobs-swisstopo-gebaeudeadressen_pub-db_1 psql --single-transaction -d pub -f /tmp/globals_geodb.rootso.org.dmp

docker cp /tmp/globals_geodb.rootso.org.dmp  gretljobs-swisstopo-gebaeudeadressen_edit-db_1:/tmp
docker exec -e PGHOST=/tmp -it  gretljobs-swisstopo-gebaeudeadressen_edit-db_1 psql --single-transaction -d edit -f /tmp/globals_geodb.rootso.org.dmp
```

```
java -jar /usr/local/ili2pg-4.3.1/ili2pg.jar \
--dbschema swisstopo_gebaeudeadressen --models OfficialIndexOfAddresses_V1 \
--defaultSrsCode 2056 --createGeomIdx --createFk --createFkIdx --createUnique --createEnumTabs --beautifyEnumDispName --createMetaInfo --createNumChecks --nameByTopic --strokeArcs \
--createscript swisstopo_gebaeudeadressen_edit.sql
```

```
export ORG_GRADLE_PROJECT_dbUriEdit=jdbc:postgresql://edit-db/edit
export ORG_GRADLE_PROJECT_dbUserEdit=gretl
export ORG_GRADLE_PROJECT_dbPwdEdit=gretl
export ORG_GRADLE_PROJECT_dbUriPub=jdbc:postgresql://pub-db/pub
export ORG_GRADLE_PROJECT_dbUserPub=gretl
export ORG_GRADLE_PROJECT_dbPwdPub=gretl
```

```
./start-gretl.sh --docker-image sogis/gretl-runtime:latest --docker-network gretljobs-swisstopo-gebaeudeadressen_default --job-directory $PWD/swisstopo_gebaeudeadressen tasks --all
```