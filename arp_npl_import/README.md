# Import und Datenumbau der Nutzungsplanung

Es gibt für den Import und Datenumbau zur Zeit je einen GRETL-Job. Ziel ist es alles in einem Job konsolidieren. Dazu fehlt aber die Anbindung eines Filesystems an GRETL-Jenkins, um auf zu importierende XTF zugreifen zu können. Der Importjob muss aus diesem Grund lokal ausgeführt werden. Wird ein GRETL-Job lokal ausgeführt, kann er aber nicht auf die notwendigen DB-Credentials für die Pub-DB zugreifen, die man für das Schreiben (also den Datenumbau) in die Pub-DB braucht. Aus diesem Grund sind zwei einzelne Jobs notwendig. Der Importrozess wird lokal "on-demand" ausgeführt, der Datenumbau-Prozess wird in GRETL-Jenkins "on-demand" ausgeführt.

Vertretbar solange Lieferungen noch eine seltene Ausnahmeerscheinung sind...

Datenumbau-SQL-Dateien lasse ich mal hier stehen. Darauf achten, dass sie ggf angepasst werden müssen, falls man im Datenumbau-Job etwas macht.

# Schema creation

See: [https://geoweb.rootso.org/redmine/issues/2677](https://geoweb.rootso.org/redmine/issues/2677)

java -jar ~/apps/ili2pg-3.11.2/ili2pg.jar \
--dbhost 192.168.50.5 \
--dbdatabase sogis \
--dbusr ddluser \
--dbpwd ddluser \
--nameByTopic \
--disableValidation \
--defaultSrsCode 2056 \
--strokeArcs \
--sqlEnableNull \
--createGeomIdx \
--createFkIdx \
--createEnumTabs \
--beautifyEnumDispName \
--createMetaInfo \
--createBasketCol \
--createDatasetCol \
--models SO_Nutzungsplanung_20171118 \
--dbschema arp_npl \
--createscript arp_npl.sql \
--schemaimport \
--createUnique \
--createFk \
--createNumChecks

Dient hier sogleich zum Testen mit einer lokalen Vagrant-Kiste.

## GRETL

Lokales arbeiten:

```
export DB_URI_SOGIS=jdbc:postgresql://192.168.50.5/sogis
export DB_USER_SOGIS=ddluser
export DB_PWD_SOGIS=ddluser
export DB_URI_PUB=jdbc:postgresql://192.168.50.XXX/pub
export DB_USER_PUB=sogis_admin
export DB_PWD_PUB=sogis_admin
```

```
./start-gretl.sh --docker_image sogis/gretl-runtime:production --job_directory /Users/stefan/Projekte/gretl-arp-import/arp_npl_import/ --task_name replaceDataset -Pxtf=2580_091_2018-02-13.xtf
```

Die XTF-Datei muss im Projektverzeichnis liegen, da nur dieses vom Docker-Image gemountet wird.