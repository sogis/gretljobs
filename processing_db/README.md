# Beispiel eines GRETL-Jobs der eine separate DB für die Prozessierung von Daten startet

## Entwicklungs-DBs starten

In diesem Fall müssen die Entwicklungs-DBs mit einem leicht anderen Befehl
gestartet werden:

```
COMPOSE_FILE=docker-compose.yml:processing_db/docker-compose.override.yml docker-compose up --build
```
