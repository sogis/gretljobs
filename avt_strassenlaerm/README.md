# avt_strassenlaerm
Die Strassenlärmdaten des AVT werden in einer Datenbank beim AVT in einer Fachanwendung (Firma G+P) bewirtschaftet. Daraus werden zwei Datensätz in zwei unterschiedlichen INTERLIS-Datenmodellen exportiert. 

Der vorliegende Job behandelt den "Strassenlärm". Es gibt ein Erfassungsmodell (resp. ein Transfermodell) und ein Publikationsmodell. Die Daten werden mittels on-demand Job in die Erfassungsdatenbank importiert. Beim Starten des Jobs wird der Benutzer aufgefordert die zu importierende Datei hochzuladen. Die Daten werden jährlich von G+P geliefert.

Das Erfassungsmodell ist ein erweitertes MGDM. Die Daten können bei Bedarf automatisch (ohne manuellen Datenumbau) in das Bundesmodell exportiert werden.

Im Web GIS Client wird _ein_ Layer (`xxxxxx` / yyyyyy) publiziert.

## Betriebsdokumentation
Zusätzlich zum Schema anlegen mittels INTERLIS-Modell, muss ein Katalog importiert werden. Es muss mit _Datasets_ gearbeitet werden und nicht mit `--deleteData`. Beim Neuimport der Geodaten kann `--deleteData` nicht verwendet werden, weil so auch zuerst die Katalogeinträge gelöscht werden und die beim Import dann fehlen. Ebenfalls kann man nicht die Kataloge löschen und neu importieren, da die Geodaten ja darauf verweisen. 

## Entwicklerdokumentation
Während der Entwicklung wurde _vagrant_ verwendet. Zukünftig wird _Docker_ zum Einsatz kommen. Auf das Einchecken der vagrant-Dateien und anderer Scriptdaten wird verzichtet. Vor allem um den GRETL-Job nicht unnötig mit Dateien zu verunreinigen. Das Entwickler-Repo ist/war hier zu finden: https://github.com/edigonzales/avt_strassenlaerm

### Edit-DB
DDL-Skript erstellen:
```
java -jar /Users/stefan/apps/ili2pg-4.3.0/ili2pg-4.3.0.jar \
--dbschema avt_strassenlaerm --models "SO_AVT_Strassenlaerm_20190806;LBK_Haupt_uebrigeStrassen_Codelisten_V1_1" \
--defaultSrsCode 2056 --strokeArcs --createGeomIdx --createFk --createFkIdx --createEnumTabs \
--beautifyEnumDispName --createMetaInfo --createUnique --createNumChecks --nameByTopic \
--createTidCol \
--createscript avt_strassenlaerm.sql
```

Import der Codeliste:
```
java -jar /Users/stefan/apps/ili2pg-4.3.0/ili2pg-4.3.0.jar --dbhost 192.168.50.7 --dbdatabase edit --dbusr ddluser --dbpwd ddluser \
--dbschema avt_strassenlaerm --models LBK_Haupt_uebrigeStrassen_Codelisten_V1_1 \
--importTid \
--import LBK_Haupt_uebrigeStrassen_Catalogues_V1_1.xml
```

Import der Daten (Kantonsmodell):
```
java -jar /Users/stefan/apps/ili2pg-4.3.0/ili2pg-4.3.0.jar --dbhost 192.168.50.7 --dbdatabase edit --dbusr ddluser --dbpwd ddluser \
--dbschema avt_strassenlaerm --models SO_AVT_Strassenlaerm_20190806 \
--importTid \
--import strassenlaerm.xtf
```

### Pub-DB
DDL-Skript erstellen:
```
java -jar /Users/stefan/apps/ili2pg-4.3.0/ili2pg-4.3.0.jar \
--dbschema avt_strassenlaerm_pub --models SO_AVT_Strassenlaerm_Publikation_20190802 \
--defaultSrsCode 2056 --strokeArcs --createGeomIdx --createFk --createFkIdx --createEnumTabs \
--beautifyEnumDispName --createMetaInfo --createUnique --createNumChecks --nameByTopic \
--createscript avt_strassenlaerm_pub.sql
```

### GRETL-Job
Lokales Testen des GRETL-Jobs:
```
export DB_URI_EDIT=jdbc:postgresql://192.168.50.7:5432/edit
export DB_USER_EDIT=ddluser
export DB_PWD_EDIT=ddluser
export DB_URI_PUB=jdbc:postgresql://192.168.50.7:5432/pub
export DB_USER_PUB=ddluser
export DB_PWD_PUB=ddluser

scripts/start-gretl.sh --docker-image sogis/gretl-runtime:production --job-directory /Users/stefan/sources/gretljobs_avt_strassenlaerm/avt_strassenlaerm/
```

Beim lokalen Testen muss mangels GUI die zu importierende Datei im Verzeichnis des GRETL-Jobs liegen und zwingend den Namen `strassenlaerm.xtf` haben. Die Datei **nicht** einchecken!
