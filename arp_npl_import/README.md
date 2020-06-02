# Import und Datenumbau der Nutzungsplanung

Es gibt für den Import und Datenumbau zur Zeit je einen GRETL-Job. Ziel ist es alles in einem Job konsolidieren. Dazu fehlt aber die Anbindung eines Filesystems an GRETL-Jenkins, um auf zu importierende XTF zugreifen zu können. Der Importjob muss aus diesem Grund lokal ausgeführt werden. Wird ein GRETL-Job lokal ausgeführt, kann er aber nicht auf die notwendigen DB-Credentials für die Pub-DB zugreifen, die man für das Schreiben (also den Datenumbau) in die Pub-DB braucht. Aus diesem Grund sind zwei einzelne Jobs notwendig. Der Importrozess wird lokal "on-demand" ausgeführt, der Datenumbau-Prozess wird in GRETL-Jenkins "on-demand" ausgeführt.

Vertretbar solange Lieferungen noch eine seltene Ausnahmeerscheinung sind...

### xtf-File umbenennen (Für Nachvollziehbarkeit in der Tabelle `arp_npl.t_ili2db_import` in der edit-DB)
```
[BSFNr]_[Datum].xtf
Beispiel: 2507_20200529.xtf
```

### xtf-File prüfen vor dem Datenimport (Nur ein selbst geprüftes XTF-File in die DB importieren)
https://geo.so.ch/ilivalidator

### Import-Datenumbau-Workflow

Gretljobs-Repo (lokal) klonen:

```
git clone https://github.com/sogis/gretljobs.git gretljobs-npl-import
```

Zu importieren XTF in das Import-Job-Verzeichnis (`arp_npl_import`) kopieren, damit diese für Gretl im Docker-Container sichbar sind.

Umgebungsvariablen für DB-Verbindung setzen. Diese werden im Docker-Container beim Ausführen des Jobs verwendet:

```
nach Umbau auf edit-DB:
export ORG_GRADLE_PROJECT_dbUriEdit=jdbc:postgresql://geodb-t.rootso.org:5432/edit?sslmode=require
export ORG_GRADLE_PROJECT_dbUserEdit=<USERNAME>
export ORG_GRADLE_PROJECT_dbPwdEdit=<PASSWORD>
```

Im `scripts`-Ordner des geklonten Repos folgender Befehl ausführen, um den Import zu starten:

```
sudo -E ../start-gretl.sh --docker-image sogis/gretl-runtime:latest --job-directory /home/bjsvwcur/gretljob-Repo/gretljobs/arp_npl_import/ replaceDataset -Pxtf=2580_091_2018-02-13.xtf
```

Ein absoluter Pfad zum `--job_directory` verursacht m.E. am wenigsten Probleme.

Wenn der Job erfolgreich durchgelaufen ist, in QGIS o.ä. überprüfen, ob die Daten tatsächlich sauber importiert wurden.

Anschliessend kann in der GRETL-Jenkins-Umgebung (`https://gretl-test.so.ch/`) der Job `arp_npl_pub` ausgeführt werden. Der zugehörige Job liegt im Verzeichnis `arp_npl_pub`. Logfiles anschauen und in QGIS o.ä. überprüfen. 

Wenn in der Test-Umgebung alles funktioniert hat, das Ganze nochmals auf der Produktion. In Zukunft dürfte wohl das Ausführen auf der Test-Umgebung überflüssig werden.

### Gretljob arp_npl_pub nachführen:
Der Gretljob arp_npl_pub  schliesst jene Gemeinden aus, welche die Nutzungsplanung schon abgeschlossen haben. 
=> `gem_bfs NOT IN (2405,2408,2457,2473,2474,2476,2498,2501,2502,2580,2613,2614,2615)`. 
Das File `arp_npl_pub/uebertrag_alte_sogisdaten_zonenplan_grundnutzung.sql` muss bei jeder neu angelegten NPL-Gemeinde um die neue BFS-Nummer erweitert werden!!

### Gretljob arp_richtplan_pub nachführen:
Der Gretljob arp_richtplan_pub schliesst jene Gemeinden aus, welche die Nutzungsplanung schon abgeschlossen haben. 
=> `gem_bfs NOT IN (2405,2408,2457,2473,2474,2476,2498,2501,2502,2580,2613,2614,2615)`. 
Das File `arp_richtplan_pub/arp_richtplan_pub_richtplankarte_grundnutzung_sogis.sql` muss bei jeder neu angelegten NPL-Gemeinde um die neue BFS-Nummer erweitert werden!!

### XTF-File ablegen unter `/opt/sogis_pic/geodata/ch.so.arp.nutzungsplanung`:
Bereits bestehendes XTF-File archivieren:
```
cd /opt/sogis_pic/geodata/ch.so.arp.nutzungsplanung
sudo mv [BFS-Nr].xtf /opt/sogis_pic/daten_archiv/arp/ch.so.arp.nutzungsplanung/[BFS-Nr]_[Archivdate].xtf
```
Neues xtf-File nach dem erfolgreichen Importieren unter `/opt/sogis_pic/geodata/ch.so.arp.nutzungsplanung` ablegen als [BFS-Nr].xtf damit sie online verfügbar sind. 

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

