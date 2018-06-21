# Import und Transformation der Nutzungsplanung

TODO: Lokal oder in GRETL-Jenkins? Berechtigungen, falls lokal?

## Information zu den Queries
### Allgemein
Das Publikationsmodell resp. die Ursprungsdatenumbau-Queries sind noch fehlerhaft, da beim Erstellen die Rekursion der ganzen Dokumenten-Geschichte wahrscheinlich nicht berücktsichtig wurde. Daher muss das Pub-Modell nochmals angepasst werden. Aber erst wenn JSON-Datentyp in ili2pg implementiert ist. 

### Kaskade 
Die Rekursion beim Datenumbau muss nochmals überprüft werden: Es kann sein, dass ein Ursprungsdokument zweimal vorkommt und jeweils eine unterschiedliche Kaskade bilden. Ich bin mir nicht sicher, ob dieser Fall abgedeckt ist. Sowas ähnliches ist mir jedenfalls aufgefallen bei den ÖREB-Transferdateien des Bundes. Gelöst habe ich es damals (Code verschollen) damit, dass ich die Ursprungsdokumente eindeutig gemacht habe, dh. die "t_id" an das "Ursprung"-Attribut gehängt. 

### Mehrfache Dokumente
Um zu verhindern, dass Dokumente mehrfach für eine Typ/Geometrie-Kombination im Publikationsmodell bei der Abfrage vorkommen, wird noch ein `DISTINCT ON (typ_grundnutzung, dok_referenz)` in der Query "typ_XXXXXXXX_dokument_ref" eingefügt.

## Schema creation

Check out: [https://geoweb.rootso.org/redmine/issues/2677](https://geoweb.rootso.org/redmine/issues/2677)

java -jar ~/apps/ili2pg-3.11.2/ili2pg.jar \
--dbhost 192.168.50.6 \
--dbdatabase pub_2 \
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
--models SO_Nutzungsplanung_Publikation_20170821 \
--dbschema arp_npl_pub \
--createscript arp_npl_pub.sql \
--schemaimport \
--createUnique \
--createFk \
--createNumChecks

## GRETL

Lokales arbeiten:

```
export DB_URI_SOGIS=jdbc:postgresql://192.168.50.6/sogis
export DB_USER_SOGIS=ddluser
export DB_PWD_SOGIS=ddluser
export DB_URI_PUB=jdbc:postgresql://192.168.50.6/pub
export DB_USER_PUB=sogis_admin
export DB_PWD_PUB=sogis_admin
```

```
./start-gretl.sh --docker_image sogis/gretl-runtime:production --job_directory /Users/stefan/Projekte/gretl-arp-import/arp_npl_import/ --task_name -Pxtf=2580_091_2018-02-13.xtf
```