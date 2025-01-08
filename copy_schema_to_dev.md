# Schema in die lokale Entwicklungs-DBs kopieren

## Bash in Entwicklungs-DB Image öffnen

In lokalem Ordner gretljobs/ ausführen, nachdem die Entwicklungs-DBs gestartet sind:

    docker compose exec -it edit-db bash

Dies öffnet ein Bash-Terminal im laufenden Container "edit-db". Im Image des Containers sind die pg_dump und pg_restore Tools in der richtigen Version enthalten.

## Dump von Schema erstellen

In der Container-Bash ausführen - Beispiel mit Schema agi_hoheitsgrenzen_pub:

    pg_dump -O -x -Fc -h geodb.rootso.org -d pub -f /tmp/latest.dump -U mylogin -n agi_hoheitsgrenzen_pub

**Keinesfalls** ohne Schemaangabe ausführen.  
mylogin ersetzen mit dem eigenen Windows Benutzernamen.

Der Befehl erstellt den Dump des Schemas in der Datei /tmp/latest.dump unter Weglassung der Berechtigungs und Tabellenowner-Informationen.

### Frage: Permission Fehler bzgl. Sequenz

    pg_dump: error: query failed: ERROR:  permission denied for sequence t_ili2db_seq
    pg_dump: detail: Query was: SELECT last_value, is_called FROM agi_hoheitsgrenzen_pub.t_ili2db_seq

### Frage: Dump nicht erstellen sondern ab Backup verwenden?

Geht nur, falls auf die Dumps auch via VPN "einfach" zugegriffen werden kann.

## Erstellten Dump lokal restoren

In der Container-Bash ausführen - Beispiel mit Schema agi_hoheitsgrenzen_pub:

    pg_restore -O -x -h pub-db -d pub -U ddluser -n agi_hoheitsgrenzen_pub /tmp/latest.dump

### Fragen: 

* Wie Schema erstellen? Restore funktioniert nur bei existierendem Schema.
* Restore mittels ddluser OK?
* Wie für korrekt gesetzte Berechtigungen für dmluser und ddluser (und weitere) sorgen? Für den dmluser existieren nach Restore beispielsweise die DML-Rechte noch nicht.
