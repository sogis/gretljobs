# Import and transformation of Nutzungsplanung

This job uses a non-production-ready gretl version! A seperate init.gradle has to be used. 

You can import a dataset (= one municipality) and do the conversion into the publication model:

* `gretl -I init.gradle replaceDataset -Pxtf=path/to/XXXX_fubar.xtf` where `XXXX` is the fos number (=BfS-Nummer) and will be checked if it's in a specific range. 
* `gretl -I init.gradle transformArpNpl`
* Or combine the two tasks.

Not sure how we will use this exactly with our gretl-jenkins.

## Information zu den Queries
### Kaskade 
Die Rekursion muss nochmals überprüft werden: Es kann sein, dass ein Ursprungsdokument zweimal vorkommt und jeweils eine unterschiedliche Kaskade bilden. Ich bin mir nicht sicher, ob dieser Fall abgedeckt ist. Sowas ähnliches ist mir jedenfalls aufgefallen bei den ÖREB-Transferdateien des Bundes. Gelöst habe ich es damals (Code verschollen) damit, dass ich die Ursprungsdokumente eindeutig gemacht habe, dh. die "t_id" an das "Ursprung"-Attribut gehängt. 

### Mehrfache Dokumente
Um zu verhindern, dass Dokumente mehrfach für eine Typ/Geometrie-Kombination im Publikationsmodell bei der Abfrage vorkommen, wird noch ein `DISTINCT ON (typ_grundnutzung, dok_referenz)` in der Query "typ_XXXXXXXX_dokument_ref" eingefügt.

## Schema creation

Check out: [https://geoweb.rootso.org/redmine/issues/2677](https://geoweb.rootso.org/redmine/issues/2677)

java -jar ~/apps/ili2pg-3.9.1/ili2pg.jar \
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

java -jar ~/apps/ili2pg-3.9.1/ili2pg.jar \
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