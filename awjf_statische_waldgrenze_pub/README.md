## Information zum GRETL-Job "pub"
## Allgemein
Die Daten aus dem Schema «arp_statische_waldgrenze» werden  publiziert. Die Daten werden zuerst gegen das Modell geprüft. 
Falls die Prüfung in Ordnung ist, werden die Daten in das Schema «arp_statische_waldgrenze_staging» (Pub-DB) importiert. Mittels Bestätigung durch die zuständigen Geschäftsverantwortlichen (AWJF) 
wird der Job weitergeführt und die Daten werden in das Publikationsschema «arp_statische_waldgrenze_pub» importiert. Das Schema «arp_statische_waldgrenze_staging» wird geleert. Die INTERLIS-Transferdatei wird zudem archiviert (Artefakte). 

## Job Ablauf
1. Export XTF-Datei aus Schema arp_statische_waldgrenze
2. Validation der INTERLIS-Dateien im Modell «SO_AWJF_Statische_Waldgrenzen_20191119»
3. Datenumabu vom Schema «arp_statische_waldgrenze» (Datenmodell «SSO_AWJF_Statische_Waldgrenzen_20191119») ins Schema «arp_statische_waldgrenze_staging» (Datenmodell «SO_AWJF_Statische_Waldgrenzen_Publikation_20191119») Import/Replace XTF in Schema «arp_statische_waldgrenze_staging»
4. Export der XTF-Datei im Modell «SO_AWJF_Statische_Waldgrenzen_Publikation_20191119»
5. Validation der INTERLIS-Dateien im Modell  «SO_AWJF_Statische_Waldgrenzen_Publikation_20191119»
6. Bestätigung (manuell) Review ist i.O. 
7. Import/Replace XTF in Schema «awjf_statische_waldgrenze_pub»
8. Schema «statische_waldgrenze_staging» leeren
9. ÖREB-GRETL-Job starten

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
./start-gretl.sh --docker-image sogis/gretl-runtime:latest --docker-network schema-jobs_default --job-directory $PWD/arp_statische_waldgrenze_pub 
```