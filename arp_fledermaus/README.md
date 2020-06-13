- Job momentan nur zum Testen der Downloadschnittstelle und der CSV-Formatierung
- Job läuft nicht im Docker-Image, sondern nur mit Plugin "direkt".




```
export ORG_GRADLE_PROJECT_dbUriEdit=jdbc:postgresql://edit-db/edit
export ORG_GRADLE_PROJECT_dbUserEdit=gretl
export ORG_GRADLE_PROJECT_dbPwdEdit=gretl
export ORG_GRADLE_PROJECT_dbUriPub=jdbc:postgresql://pub-db/pub
export ORG_GRADLE_PROJECT_dbUserPub=gretl
export ORG_GRADLE_PROJECT_dbPwdPub=gretl

export ORG_GRADLE_PROJECT_fledermausUser=xxxxx
export ORG_GRADLE_PROJECT_fledermausPwd='yy!yy'
```