## Information zum GRETL-Job "pub"
## Allgemein
Die Daten aus dem Schema «arp_nutzungsplanung» (Datenmodell «SO_ARP_Nutzungsplanung_Nachfuehrung_20201005») werden pro Dataset (BFS-Nr.) publiziert. Die Daten werden zuerst mit dem Validierungsmodell geprüft. 
Falls die Prüfung in Ordnung ist, werden die Daten in das Schema «arp_nutzungsplanung_staging» importiert. Mittels Bestätigung durch die zuständigen Geschäftsverantwortlichen (z.B. Gemeinde, Kreisplanende oder Nachführungsstelle Nutzungsplanung) 
wird der Job weitergeführt und die Daten werden in das Publikationsschema «arp_nutzungsplanung_pub» importiert. Das Schema «arp_nutzungsplanung_staging» wird geleert. Die INTERLIS-Transferdatei wird zudem archiviert (Artefakte). 
Die Publikation wird pro Dataset (BFS-Nr.) ausgeführt. So kann definiert werden, von welcher Gemeinde die Publikation erfolgen sollen.

Hinweis für Publikation Kanton gibt es ein eignener GRETL-Job.

## Job Ablauf
1. xxxx


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
./start-gretl.sh --docker-image sogis/gretl-runtime:latest --docker-network schema-jobs_default --job-directory $PWD/arp_nutzungsplanung_pub -Pili2pgDataset='2457'
```