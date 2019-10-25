# Entwicklerdokumentation
Während der Entwicklung wurde _vagrant_ verwendet. Zukünftig wird _Docker_ zum Einsatz kommen. Auf das Einchecken der vagrant-Dateien und andere Scriptdaten wird verzichtet. Vor allem um den GRETL-Job nicht unnötig mit Dateien zu verunreinigen. Das Entwickler-Repo ist/war hier zu finden: https://github.com/edigonzales/avt_strassenlaerm

## Import Entwicklungsdatenbank (vagrant)
```
java -jar /Users/stefan/apps/ili2pg-3.12.2/ili2pg-3.12.2.jar --dbhost 192.168.50.7 --dbdatabase pub --dbusr ddluser --dbpwd ddluser \
--dbschema avt_groblaermkataster_pub --models SO_AVT_Groblaermkataster_20190709 \
--defaultSrsCode 2056 --strokeArcs --createGeomIdx --createFk --createFkIdx --createEnumTabs \
--beautifyEnumDispName --createMetaInfo --createUnique --createNumChecks --nameByTopic \
--schemaimport 
```

```
java -jar /Users/stefan/apps/ili2pg-3.12.2/ili2pg-3.12.2.jar --dbhost 192.168.50.7 --dbdatabase pub --dbusr ddluser --dbpwd ddluser \
--dbschema avt_groblaermkataster_pub --models SO_AVT_Groblaermkataster_20190709 \
--defaultSrsCode 2056 --strokeArcs --createGeomIdx --createFk --createFkIdx --createEnumTabs \
--beautifyEnumDispName --createMetaInfo --createUnique --createNumChecks --nameByTopic \
--disableValidation --deleteData \
--import Groblaermkataster/groblaermkataster_20190806.xtf
```

## Schemaimport GDI
```
java -jar /usr/local/ili2pg-3.11.2/ili2pg.jar --dbhost $DBHOST --dbport 5432 --dbdatabase pub --dbusr $USER --dbpwd $(awk -v dbhost=$DBHOST -F ':' '$1~dbhost{print $5}' ~/.pgpass) \
--schemaimport --dbschema avt_groblaermkataster_pub --models SO_AVT_Groblaermkataster_20190709 \
--defaultSrsCode 2056 --strokeArcs --createGeomIdx --createFk --createFkIdx --createEnumTabs \
--beautifyEnumDispName --createMetaInfo --createUnique --createNumChecks --nameByTopic \
--preScript prescript.sql --postScript postscript.sql
```

## GRETL-Job
Nach dem Starten des on-demand GRETL-Jobs (`avt_groblaermkataster_pub`) wird der Benutzer dazu aufgefordert die zu importierende Datei hochzuladen.

Lokales Testen des GRETL-Jobs:
```
export DB_URI_PUB=jdbc:postgresql://192.168.50.7:5432/pub
export DB_USER_PUB=ddluser
export DB_PWD_PUB=ddluser

scripts/start-gretl.sh --docker-image sogis/gretl-runtime:production --job-directory /Users/stefan/sources/gretljobs_avt_groblaermkataster/avt_groblaermkataster_pub/
```
Beim lokalen Testen muss mangels GUI die zu importierende Datei im Verzeichnis des GRETL-Jobs liegen und zwingend den Namen `groblaermkataster.xtf` haben. Die Datei **nicht** einchecken!



