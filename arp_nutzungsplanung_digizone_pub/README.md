## Information zum GRETL-Job "digizone_pub"
## Allgemein
Auf der alten SO!GIS-DB gab es im QGIs ein Plug-In "digizone" wo die Grundnutzungen im Baugebiet vom ARP erfasst wurden. 
Mit der Ersterfassung der Nutzungsplanungsdaten werden diese Daten abgelöst. Da die Flächendeckung noch nicht erreicht ist, werden in einer Übergangsfrist die Daten "digizone" mit den Daten der Ersterfassung zusammen geführt.
In der Edit-DB sind die Daten im Modell 'SO_ARP_Nutzungsplanung_Publikation_20201005'. Es ist deshalb nur ein INTERLIS-Export und ein INTERLIS-Import nötig. 
Falls von einer Gemeinde Daten der Ersterhebung kommen, müssen die Daten von dieser Gemeinde im Schema «arp_nutzungsplanung_digizone» manuell gelöscht werden. 


## Job Ablauf
1. Export XTF-Datei aus Schema arp_nutzungsplanung_digizone_v1
2. Validation der INTERLIS-Dateien
3. Import/Replace XTF in Schema «arp_nutzungsplanung_pub» Dataset=digizone


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