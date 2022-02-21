## Information zum GRETL-Job "import"
## Allgemein
Diese GRETL-Job ist dazu gedacht, INTERLIS-Transferdatei im Datenmodell «SO_Nutzungsplanung_20171118» (Ersterfassungen oder Teilzonenrevisionen) in das Schema «arp_nutzungsplanung» zu importieren.
Dies braucht es für die Migration aber auch wenn Daten von Planungsbüro kommen für eine ganze Gemeinde. Z.B. Ersterfassung oder Ortsplanungsrevision. 
Dazu wird ein Schema benötigt «arp_nutzungsplanung_import». Die Daten werden zuerst in das Schema «arp_nutzungsplanung_import» (Datenmodell «SO_Nutzungsplanung_20171118») importiert und dann umgebaut in das Schema «arp_nutzungsplanung_transfer». 
Dann werden die Daten aus dem Schema «arp_nutzungsplanung_transfer» exportiert. Einmal Dataset= BFS-Nr. und einmal dataset= 'Kanton'.
Die Daten im Schema «arp_nutzungsplanung_import» und «arp_nutzungsplanung_transfer» werden wieder gelöscht. Das Schema «arp_nutzungsplanung_transfer» wird benötigt, da der Datenumbau mit Basket, tid und Sequenz einfacher ist. 
In das Schema «arp_nutzungsplanung» und «arp_nutzungsplanung_kanton» werden dadurch immer nur INTERLIS-Transferdatei importiert. Datasetnamen resp. die BFS-Nr. (Parameter) kann angegeben werden. 

Hinweis:
Schema «arp_nutzungsplanung_kanton» braucht es, weil der Import von INTERLIS-Daten mit dem gleichen Datasetname nur mit Replace möglich ist. Es gibt beim Dataset «Kanton» pro Gemeinde ein INTERLIS-Datei und man möchte die Daten ergänzen (dazutun) und nicht ersetzen. 
Deshalb ist das Schema «arp_nutzungsplanung_kanton» ohne --createBasketCol --createDatasetCol angelegt.

Für ein Dataset (BFS-Nr.) aus dem Schema "arp_nutzungsplanung" zu löschen gibt es ein eigener Gretljob. Daten aus dem Schema «arp_nutzungsplanung_kanton» müssen manuell gelöscht werden.

## Job Ablauf
1. XTF-Datei hochladen und Parameter (BFS-Nr.) angeben (dazu braucht es das Jenkinsfile).
2. Import in Schema «arp_nutzungsplanung_import» (deleteData d.h. die Daten werden vorgängig gelöscht aber Basket Tabelle löscht es nicht, deshalb Schritt 5. nötig)
2. XTF im upload-Ordner löschen
3. Schema «arp_nutzungsplanung_transfer» leeren mit SQL-Skript
4. Daten Umbau mit SQL-Skript
5. Dataset (BFS-Nr.) löschen aus «arp_nutzungsplanung_import» (löscht auch die Einträge in Tabelle basket)
6. Export Dataset «BFS-Nr.» und «Kanton» aus Schema «arp_nutzungsplanung_transfer»
7. Validation der INTERLIS-Dateien «BFS-Nr.» und «Kanton» 
8. Import ins Schema «arp_nutzungsplanung» und «arp_nutzungsplanung_kanton»
9. Falls Import eine Fehlermeldung gibt, müssen die Daten im Schema «arp_nutzungsplanung_transfer» manuell korrigiert werden. Ab Schritt 6. wird dann der Job weitergeführt
10. INTERLIS-Dateien «BFS-Nr.» und «Kanton» löschen


## GRETL
Lokales arbeiten:
Parameter:
```
export ORG_GRADLE_PROJECT_dbUriEdit=jdbc:postgresql://edit-db/edit
export ORG_GRADLE_PROJECT_dbUserEdit=gretl
export ORG_GRADLE_PROJECT_dbPwdEdit=gretl
export ORG_GRADLE_PROJECT_dbUriPub=jdbc:postgresql://pub-db/pub
export ORG_GRADLE_PROJECT_dbUserPub=gretl
export ORG_GRADLE_PROJECT_dbPwdPub=gretl
```
nur Lokal ein Ordner "upload" anlegen im Gretljob Verzeichnis. XTF-Datei in das Verzeichnis kopieren mit der Benennung "uploadFile" 
```
./start-gretl.sh --docker-image sogis/gretl-runtime:latest --docker-network schema-jobs_default --job-directory $PWD/arp_nutzungsplanung_import -Pili2pgDataset='2457'
```
