# GRETL-Job alw_fruchtfolgeflaechen, der eine separate DB für die Prozessierung von Daten startet

Dieser GRETL-Job umfasst weist ein eigens Jenkinsfile auf,
in welchem definiert ist, dass im GRETL-Pod zusätzlich zum
GRETL-Container auch ein DB-Container gestartet werden soll.


## Entwicklungs-DBs starten

In diesem Fall müssen die Entwicklungs-DBs
mit einem leicht anderen Befehl gestartet werden
(wobei die Option `--build` auch hier grundsätzlich weggelassen werden kann);
der Befehl muss aus der obersten Verzeichnisebene
des Git-Repositories ausgeführt werden:

```
COMPOSE_FILE=docker-compose.yml:alw_fruchtfolgeflaechen/docker-compose.override.yml docker-compose up --build
```

Das Stoppen der Entwicklungs-DBs funktioniert analog:

```
COMPOSE_FILE=docker-compose.yml:alw_fruchtfolgeflaechen/docker-compose.override.yml docker-compose down
```


## GRETL-Job lokal ausführen

In diesem Fall müssen vor dem Ausführen des GRETL-Wrapperskripts
zusätzlich folgende Umgebungsvariablen gesetzt werden:

```
export ORG_GRADLE_PROJECT_dbUriProcessing=jdbc:postgresql://processing-db/processing
export ORG_GRADLE_PROJECT_dbUserProcessing=user
export ORG_GRADLE_PROJECT_dbPwdProcessing=pass
```
