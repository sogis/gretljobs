## Information zum GRETL-Job "delete_dataset"
## Allgemein
Löschung von Dataset mit ili2pg Befehl (--delete --dataset) im Schema «arp_nutzungsplanung». Der Datasetname z.B. «2407» oder «2407_prov» kann angegeben werden. 

## Job Ablauf
1. XTF-Datei mit Dataset, das gelöscht werden soll, wird als Datensicherung exportiert (Artefakte).
2. Löscht die Daten mit dem angegebenen Dataset (BFS-Nr.) aus dem Schema «arp_nutzungsplanung».

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
```
./start-gretl.sh --docker-image sogis/gretl-runtime:latest --docker-network schema-jobs_default --job-directory $PWD/arp_nutzungsplanung_delete_dataset -Pili2pgDataset='2457'
```