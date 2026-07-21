# Schema in die lokale Entwicklungs-DB kopieren

## Schema-Dump erzeugen und in lokalem Linux speichern

Im produktiven GRETL-Jenkins den Job _agi_schema_dump_ ausführen.
Der Job funktioniert für die Edit-, Publikations- und ÖREB-DB.
Es können ein oder mehrere Schemas (mit Leerschlag getrennt) für den Export angegeben werden.
Nach Ausführung stehen die Dumps als Build-Artefakt `schemaname.dump` zur Verfügung.

Diese herunterladen und im Verzeichnis `/tmp` des lokalen (WSL-)Linux speichern.

## Schema-Berechtigungen anwenden

Setzen der Schema-Berechtigungen für Benutzer dmluser und die Rollen \[Schemaname\]_read und \[Schemaname\]_write.

Dazu in der ersten Zeile des folgenden Skripts "mySchema" mit dem Schemanamen ersetzen und das Skript im DBeaver auf die lokale Edit-DB oder Pub-DB anwenden.

    @set dbSchema = mySchema

    DROP SCHEMA IF EXISTS ${dbSchema};
    CREATE SCHEMA ${dbSchema};

    -- role _read with privileges

    DROP ROLE IF EXISTS ${dbSchema}_read;
    CREATE ROLE ${dbSchema}_read;

    GRANT USAGE ON SCHEMA ${dbSchema} TO ${dbSchema}_read;

    ALTER DEFAULT PRIVILEGES IN SCHEMA ${dbSchema} GRANT SELECT ON TABLES TO ${dbSchema}_read;

    -- role _write wih privileges

    DROP ROLE IF EXISTS ${dbSchema}_write;
    CREATE ROLE ${dbSchema}_write;

    GRANT USAGE ON SCHEMA ${dbSchema} TO ${dbSchema}_write;

    ALTER DEFAULT PRIVILEGES IN SCHEMA ${dbSchema} GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${dbSchema}_write;
    ALTER DEFAULT PRIVILEGES IN SCHEMA ${dbSchema} GRANT USAGE ON SEQUENCES TO ${dbSchema}_write;

    -- grant for dmluser

    GRANT ${dbSchema}_write TO dmluser;

## Heruntgergeladenen Dump lokal restoren

Im lokalen Ordner `gretljobs` einen der folgenden Befehle ausführen, nachdem die Entwicklungs-DBs gestartet sind:
* Für Restore in die Edit-DB:
  ```
  docker compose run --rm -v /tmp:/tmp edit-db pg_restore -h edit-db -d edit -U ddluser -O -n my_schema /tmp/my_schema.dump
  ```
* Für Restore in die Pub-DB:
  ```
  docker compose run --rm -v /tmp:/tmp pub-db pg_restore -h pub-db -d pub -U ddluser -O -n my_schema /tmp/my_schema.dump
  ```

(`mySchema` jeweils mit dem effektiven Schemanamen ersetzen.)

Dumps von nicht mittels Schemajob erstellten Schemen enthalten direkte Grants von Benutzer(gruppen) auf Tabellen, ... des Schemas.
Dies führt zu Fehlermeldungen im Stil von:

    pg_restore: error: could not execute query: ERROR:  role "bjsvw" does not exist
    Command was: GRANT SELECT ON TABLE agi_av_gb_abgleich_import.gb_daten TO bjsvw;
    GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE agi_av_gb_abgleich_import.gb_daten TO gretl;

Die Fehlermeldungen stören die lokale Nutzung des Schemas nicht (Daten werden trotzdem importiert).
