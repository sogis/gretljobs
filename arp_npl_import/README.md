# Import und Datenumbau der Nutzungsplanung

Es gibt für den Import und Datenumbau zur Zeit je einen GRETL-Job. Ziel ist es alles in einem Job konsolidieren. 

### xtf-File prüfen vor dem Datenimport 
Nur ein selbst geprüftes XTF-File in die DB importieren
https://geo.so.ch/ilivalidator

### Import-Datenumbau-Workflow

* Gretljobs starten
* Build
* Datei hochladen => "Please redirect to approve" auswählen
  * File auswählen
  * BFS-Nr. angeben
* Proceed

Wenn in der Test-Umgebung alles funktioniert hat, das Ganze nochmals auf der Integration und anschliessend in der Produktion. 

### Gretljob arp_npl_pub nachführen:
Der Gretljob arp_npl_pub  schliesst jene Gemeinden aus, welche die Nutzungsplanung schon abgeschlossen haben. 
=> `gem_bfs NOT IN (2405,2408,2457,2473,2474,2476,2498,2501,2502,2580,2613,2614,2615)`. 
Das File `arp_npl_pub/uebertrag_alte_sogisdaten_zonenplan_grundnutzung.sql` muss bei jeder neu angelegten NPL-Gemeinde um die neue BFS-Nummer erweitert werden!!

### Gretljob arp_richtplan_pub nachführen:
Der Gretljob arp_richtplan_pub schliesst jene Gemeinden aus, welche die Nutzungsplanung schon abgeschlossen haben. 
=> `gem_bfs NOT IN (2405,2408,2457,2473,2474,2476,2498,2501,2502,2580,2613,2614,2615)`. 
Das File `arp_richtplan_pub/arp_richtplan_pub_richtplankarte_grundnutzung_sogis.sql` muss bei jeder neu angelegten NPL-Gemeinde um die neue BFS-Nummer erweitert werden!!

### XTF-File ablegen 
`/opt/sogis_pic/geodata/ch.so.arp.nutzungsplanung` und `/opt/sogis_pic/daten_archiv/arp/ch.so.arp.nutzungsplanung/`

XTF-File archivieren:
```
cd /opt/sogis_pic/daten_archiv/arp/ch.so.arp.nutzungsplanung/
[BFS-Nr]_[Lieferdatum].xtf
Beispiel: 2507_2020-05-29.xtf
Rechte setzen: sudo chmod 644 [BFS-Nr]_[Lieferdatum].xtf
```
XTF-File Ablegen damit es Online zur Vefügung steht:
```
cd opt/sogis_pic/geodata/ch.so.arp.nutzungsplanung
[BFS-Nr].xtf
Rechte setzen: sudo chmod 644 [BFS-Nr].xtf
```

### Datenupdate für Oereb:
Nach dem erfolgreichen Import in die edit-DB und pub-DB muss der Oereb nachgeführt werden.


## Entwicklung
See: [https://geoweb.rootso.org/redmine/issues/3891](https://geoweb.rootso.org/redmine/issues/3891)

`java -jar /usr/local/ili2pg-4.3.1/ili2pg.jar \
--dbschema arp_npl --models SO_Nutzungsplanung_20171118 \
--defaultSrsCode 2056 --strokeArcs --createGeomIdx --createFk --createFkIdx --createEnumTabs --beautifyEnumDispName --createMetaInfo --createUnique --createNumChecks --nameByTopic \
--createBasketCol --createDatasetCol \
--createscript arp_npl.sql`

`psql -h geodb-t.rootso.org -d edit -c "SET ROLE admin" --single-transaction -f arp_npl.sql -f postscript.sql`


Dient hier sogleich zum Testen mit einer lokalen Vagrant-Kiste.

