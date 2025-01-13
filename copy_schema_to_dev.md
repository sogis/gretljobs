# Schema in die lokale Entwicklungs-DBs kopieren

## Schema-Dump erzeugen und in lokalem Linux speichern

In GRETL-Jenkins den Job "agi_schema_dump" ausführen. Nach Ausführung steht der Dump als Build-Artefakt "schema.dump" zur Verfügung.

Dieses herunterladen und im Verzeichnis /tmp des lokalen (WSL-)Linux speichern.

## Schema-Berechtigungen anwenden

Setzen der Schema-Berechtigungen für Benutzer dmluser und die Rollen \[Schemaname\]_read und \[Schemaname\]_write.

Dazu in der ersten Zeile des folgenden Skripts "mySchema" mit dem Schemanamen ersetzen und das Skript im DBeaver auf die lokale Edit-DB oder Pub-DB anwenden.

    @set dbSchema = mySchema

    CREATE SCHEMA IF NOT EXISTS ${dbSchema};

    DROP ROLE IF EXISTS ${dbSchema}_read;
    CREATE ROLE ${dbSchema}_read;

    DROP ROLE IF EXISTS ${dbSchema}_write;
    CREATE ROLE ${dbSchema}_write;

    /* Copied from schema-jobs/shared/recreate_role.sql with removal of param "roleSuffix" */

    -- Drop role with read privilege
    REVOKE ALL PRIVILEGES
    ON SCHEMA ${dbSchema}
    FROM ${dbSchema}_read;

    REVOKE ALL PRIVILEGES
    ON ALL TABLES IN SCHEMA ${dbSchema}
    FROM ${dbSchema}_read;

    DROP ROLE ${dbSchema}_read;

    -- Drop role with write privilege
    REVOKE ALL PRIVILEGES
    ON SCHEMA ${dbSchema}
    FROM ${dbSchema}_write;

    REVOKE ALL PRIVILEGES
    ON ALL TABLES IN SCHEMA ${dbSchema}
    FROM ${dbSchema}_write;

    REVOKE ALL PRIVILEGES
    ON ALL SEQUENCES IN SCHEMA ${dbSchema}
    FROM ${dbSchema}_write;

    DROP ROLE ${dbSchema}_write;

    -- Create role with read privilege
    CREATE ROLE ${dbSchema}_read;

    GRANT USAGE ON SCHEMA ${dbSchema} TO ${dbSchema}_read;

    GRANT SELECT
    ON ALL TABLES IN SCHEMA ${dbSchema}
    TO ${dbSchema}_read;

    -- Create role with write privilege
    CREATE ROLE ${dbSchema}_write;

    GRANT USAGE ON SCHEMA ${dbSchema} TO ${dbSchema}_write;

    GRANT SELECT, INSERT, UPDATE, DELETE
    ON ALL TABLES IN SCHEMA ${dbSchema}
    TO ${dbSchema}_write;

    GRANT USAGE
    ON ALL SEQUENCES IN SCHEMA ${dbSchema}
    TO ${dbSchema}_write;

    /* Copied from schema-jobs/shared/development_tasks/grants_developmen.sql with removal of param "roleSuffix" */
    GRANT ${dbSchema}_write TO dmluser;

Skript-Fenster in DBeaver offen behalten, da das gleiche Skript nach dem Restore des Dumps ein zweites Mal ausgeführt wird.

## Heruntgergeladenen Dump lokal restoren

### Bash in Entwicklungs-DB Container öffnen

In lokalem Ordner gretljobs/ ausführen, nachdem die Entwicklungs-DBs gestartet sind:

    docker compose run --rm db-tools bash

Dies öffnet ein Bash-Terminal im Container "db-tools". Im Image des Containers sind die PG-Tools in der richtigen Version enthalten.

### In der Container-Bash ausführen

Template für Edit-DB:

    pg_restore -O -x -h edit-db -d edit -U ddluser -n mySchema /tmp/schema.dump

Template für Pub-DB:

    pg_restore -O -x -h pub-db -d pub -U ddluser -n mySchema /tmp/schema.dump

Hinter -n "mySchema" mit dem effektiven Schemanamen ersetzen

## Schema-Berechtigungen erneut anwenden

Skript aus Kapitel "Schema-Berechtigungen anwenden" ein zweites Mal mittels DBeaver ausführen.
