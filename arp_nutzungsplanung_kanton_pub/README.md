## Information zum GRETL-Job "pub"
## Allgemein
Die Daten aus dem Schema «arp_nutzungsplanung_kanton» (Datenmodell «SO_ARP_Nutzungsplanung_Nachfuehrung_20201005») werden publiziert. Die Daten werden zuerst mit dem Validierungsmodell geprüft. 
Falls die Prüfung in Ordnung ist, werden die Daten in das Schema «arp_nutzungsplanung_staging» importiert. Mittels Bestätigung durch die zuständigen Geschäftsverantwortlichen (z.B. Gemeinde, Kreisplanende oder Nachführungsstelle Nutzungsplanung) 
wird der Job weitergeführt und die Daten werden in das Publikationsschema «arp_nutzungsplanung_pub» importiert. Das Schema «arp_nutzungsplanung_staging» wird geleert. Die INTERLIS-Transferdatei wird zudem archiviert (Artefakte). 
Die Publikation wird über den ganzen Kanton ausgeführt. Schema arp_nutzungsplanung_transfer_pub ist nötig damit die Replace funktion von ili2pg im Schema 
«arp_nutzungsplanung_staging» und «arp_nutzungsplanung_pub» verwendet werden kann. Schema arp_nutzungsplanung_transfer_pub wird auch für Gretljob arp_nutzungsplanung_pub verwendet 

Hinweis für Publikation Kanton gibt es ein eignener GRETL-Job.

## Job Ablauf
1. Schema «arp_nutzungsplanung_transfer_pub» leeren
2. Export XTF-Datei aus Schema arp_nutzungsplanung_kanton
3. Validation der INTERLIS-Dateien im Modell «SO_ARP_Nutzungsplanung_Nachfuehrung_20201005» mit dem Validierungsmodell «SO_ARP_Nutzungsplanung_Nachfuehrung_20201005_Validierung_20201005» (mit ini-Datei)
4. Datenumabu vom Schema «arp_nutzungsplanung_kanton» (Datenmodell «SO_ARP_Nutzungsplanung_Nachfuehrung_20201005») ins Schema «arp_nutzungsplanung_transfer_pub» (Datenmodell «SO_ARP_Nutzungsplanung_Publikation_20201005»)
5. Export der XTF-Datei im Modell «SO_ARP_Nutzungsplanung_Publikation_20201005»
6. Validation der INTERLIS-Dateien im Modell  «SO_ARP_Nutzungsplanung_Publikation_20201005»
7. Import/Replace XTF in Schema «arp_nutzungsplanung_staging»
8. Bestätigung (manuell) Review ist i.O. 
9. Import/Replace XTF in Schema «arp_nutzungsplanung_pub»
10. Dataset aus Schema «arp_nutzungsplanung_staging» löschen

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
./start-gretl.sh --docker-image sogis/gretl-runtime:latest --docker-network schema-jobs_default --job-directory $PWD/arp_nutzungsplanung_pub 
```