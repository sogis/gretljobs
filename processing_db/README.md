# Beispiel eines GRETL-Jobs der eine separate DB für die Prozessierung von Daten startet

## Entwicklungs-DBs starten

In diesem Fall müssen die Entwicklungs-DBs
mit einem leicht anderen Befehl gestartet werden
(wobei die Option `--build` auch hier grundsätzlich weggelassen werden kann):

```
COMPOSE_FILE=docker-compose.yml:processing_db/docker-compose.override.yml docker-compose up --build
```

## GRETL-Job lokal ausführen

In diesem Fall müssen vor dem Ausführen des GRETL-Wrapperskripts
zusätzlich folgende Umgebungsvariablen gesetzt werden:

```
export ORG_GRADLE_PROJECT_dbUriProcessing=jdbc:postgresql://processing-db/processing
export ORG_GRADLE_PROJECT_dbUserProcessing=user
export ORG_GRADLE_PROJECT_dbPwdProcessing=pass
```
