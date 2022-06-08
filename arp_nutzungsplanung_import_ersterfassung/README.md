## Information zum GRETL-Job "import"
## Allgemein
Diese GRETL-Job ist dazu gedacht, INTERLIS-Transferdatei im Datenmodell «SO_Nutzungsplanung_20171118» (Ersterfassungen oder Teilzonenrevisionen) in die Review-Umgebung (Web GIS Client) Schema «arp_nutzungsplanung_sating» zu importieren.
Dazu wird ein Schema benötigt «arp_nutzungsplanung_import». Die Daten werden zuerst in das Schema «arp_nutzungsplanung_import» (Datenmodell «SO_Nutzungsplanung_20171118») importiert und dann umgebaut in das Schema «arp_nutzungsplanung_transfer»(keine Aufsplitterung zwischen BFS-Nr. und Kanton). 
Danach werden die Daten umgebaut in das Schema «arp_nutzungsplanung_transfer_pub» und dann importiert in das Schema «arp_nutzungsplanung_staging»
Die Daten im Schema «arp_nutzungsplanung_import», «arp_nutzungsplanung_transfer» und «arp_nutzungsplanung_transfer_pub» werden wieder gelöscht. Das Schema «arp_nutzungsplanung_transfer» und «arp_nutzungsplanung_transfer_pub» wird benötigt, da der Datenumbau mit Basket, tid und Sequenz einfacher ist. 
In das Schema «arp_nutzungsplanung_staging» u werden dadurch immer nur INTERLIS-Transferdatei importiert. Datasetnamen resp. die BFS-Nr. (Parameter) kann angegeben werden. 


## Job Ablauf
1. XTF-Datei hochladen und Parameter (BFS-Nr.) angeben (dazu braucht es das Jenkinsfile).
2. Import in Schema «arp_nutzungsplanung_import» (deleteData d.h. die Daten werden vorgängig gelöscht aber Basket Tabelle löscht es nicht, deshalb Schritt 5. nötig)
2. XTF im upload-Ordner löschen
3. Schema «arp_nutzungsplanung_transfer» leeren mit SQL-Skript
4. Daten Umbau mit SQL-Skript
5. Dataset (BFS-Nr.) löschen aus «arp_nutzungsplanung_import» (löscht auch die Einträge in Tabelle basket)
6. leert des Schema «arp_nutzungsplanung_transfer_pub»
7. Export Dataset «BFS-Nr.» Schema «arp_nutzungsplanung_transfer»
8. Validation der INTERLIS-Dateien «BFS-Nr.»
9. Datenumbau mit SQL-Skript im Pub-Struktur
9. Export Dataset «BFS-Nr.» Schema «arp_nutzungsplanung_transfer_pub»
10. Validation der INTERLIS-Dateien «BFS-Nr.»
8. Import ins Schema «arp_nutzungsplanung_staging»
9. Falls Import eine Fehlermeldung gibt, müssen die Daten im Schema «arp_nutzungsplanung_transfer» manuell korrigiert werden. Ab Schritt 6. wird dann der Job weitergeführt
10. INTERLIS-Dateien «BFS-Nr.» 


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
 ./start-gretl.sh --docker-image sogis/gretl:latest --docker-network schema-jobs_alt_default --job-directory $PWD/arp_nutzungsplanung_import_ersterfassung importXTF_stage -Pili2pgDataset='2555'
```
