```
java -jar /usr/local/ili2pg-4.3.1/ili2pg.jar \
--dbschema swisstopo_gebaeudeadressen --models OfficialIndexOfAddresses_V1 \
--defaultSrsCode 2056 --createGeomIdx --createFk --createFkIdx --createUnique --createEnumTabs --beautifyEnumDispName --createMetaInfo --createNumChecks --nameByTopic --strokeArcs \
--createscript swisstopo_gebaeudeadressen_edit.sql
```



```
./start-gretl.sh --docker-image sogis/gretl-runtime:latest --docker-network gretljobs-swisstop-adressen_default --job-directory $PWD/swisstopo_gebaeudeadressen tasks --all

```