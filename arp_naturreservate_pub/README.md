## Information zum GRETL-Job "pub"
## Allgemein
Die Daten aus dem Schema «arp_naturreservate» (Datenmodell «SO_ARP_Naturreservate_20200609») werden  publiziert. Die Daten werden zuerst gegen das Modell geprüft. 
Falls die Prüfung in Ordnung ist, werden die Daten in das Schema «arp_naturreservate_staging» (Pub-DB) importiert. Mittels Bestätigung durch die zuständigen Geschäftsverantwortlichen (ARP) 
wird der Job weitergeführt und die Daten werden in das Publikationsschema «arp_naturreservate_pub» importiert. Das Schema «arp_naturreservate_staging» wird geleert. Die INTERLIS-Transferdatei wird zudem archiviert (Artefakte). 

## Job Ablauf
1. Export XTF-Datei aus Schema arp_naturreservate
2. Validation der INTERLIS-Dateien im Modell «SO_ARP_Naturreservate_20200609»
3. Datenumabu vom Schema «arp_naturreservate» (Datenmodell «SO_ARP_Naturreservate_20200609») ins Schema «arp_naturreservate_staging» (Datenmodell «SO_ARP_Naturreservate_Publikation_20200609») Import/Replace XTF in Schema «arp_naturreservate_staging»
4. Export der XTF-Datei im Modell «SO_ARP_Naturreservate_Publikation_20200609»
5. Validation der INTERLIS-Dateien im Modell  «SO_ARP_Naturreservate_Publikation_20200609»
6. Bestätigung (manuell) Review ist i.O. 
7. Import/Replace XTF in Schema «arp_nutzungsplanung_pub»
8. Schema «arp_nutzungsplanung_staging» leeren
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
./start-gretl.sh --docker-image sogis/gretl-runtime:latest --docker-network schema-jobs_default --job-directory $PWD/arp_nutzungsplanung_pub -Pbfsnr='2457'
```