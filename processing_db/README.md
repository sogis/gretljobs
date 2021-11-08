# Beispiel eines GRETL-Jobs der eine separate DB für die Prozessierung von Daten startet

## Entwicklungs-DBs starten

In diesem Fall müssen die Entwicklungs-DBs
mit einem leicht anderen Befehl gestartet werden
(wobei die Option `--build` auch hier grundsätzlich weggelassen werden kann):

```
COMPOSE_FILE=docker-compose.yml:processing_db/docker-compose.override.yml docker-compose up --build
```

## GRETL-Job lokal ausführen

In diesem Fall muss dem GRETL-Wrapperskript `start-gretl.sh`
zusätzlich die Property `-PprocessingDbHost=processing-db` übergeben werden.
(Der übergebene Wert muss dem Service-Namen
in `docker-compose.override.yaml` entsprechen.)
Beispiel:

```
./start-gretl.sh --docker-image sogis/gretl-runtime:latest [--docker-network NETWORK] --job-directory $PWD/jobname -PprocessingDbHost=processing-db [taskName...] [--option-name...]
```
