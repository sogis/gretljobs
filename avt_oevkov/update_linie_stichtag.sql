-- Alle Einträge in Tabelle sachdaten_linie_route als "nicht verwendet am Stichtag"
-- markieren, welche nicht zum Stichtag gehören

-- zuerst Kommentare für bereits verwendeten Stichtag löschen
UPDATE avt_oevkov_${currentYear}_v1.sachdaten_linie_route
SET
    kommentar = NULL
WHERE
    kommentar LIKE 'nicht verwendet am Stichtag %'
;

WITH calendar AS (
    SELECT
        service_id,
    CASE
        WHEN (
            SELECT BTRIM(lower(to_char((
                SELECT
                     stichtag
                FROM
                    avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten), 'Day')))
        ) = 'thursday'
            THEN thursday
        WHEN (
             SELECT BTRIM(lower(to_char((
                 SELECT
                     stichtag
                 FROM
                     avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten), 'Day')))
        ) = 'tuesday'
            THEN tuesday
    END AS dayofweek
    FROM
        avt_oevkov_${currentYear}_v1.gtfs_calendar
),
exception AS (
    SELECT
        service_id,
        exception_type
    FROM
        avt_oevkov_${currentYear}_v1.gtfs_calendar_dates
    WHERE
        datum = (
                SELECT
                    stichtag
                FROM
                    avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten)
),
trips AS (
    SELECT route_id
    FROM 
        avt_oevkov_${currentYear}_v1.gtfs_trip
    WHERE
        (
        service_id IN (
            SELECT
                service_id
            FROM
                calendar
            WHERE dayofweek = 1
        )
        OR
            -- exception_type = 1: Der Fahrbetrieb wurde für das angegebene Datum hinzugefügt.
            service_id IN (
                SELECT
                    service_id
                FROM
                    exception
                WHERE
                    exception_type = 1
            )
        )
        AND
            -- exception_type = 2: Der Fahrbetrieb wurde für das angegebene Datum entfernt.
            service_id NOT IN (
                SELECT
                    service_id
                FROM
                    exception
                WHERE
                    exception_type = 2
        )
)
UPDATE avt_oevkov_${currentYear}_v1.sachdaten_linie_route
    SET
        kommentar = 'nicht verwendet am Stichtag '
                    ||( SELECT
                             to_char(stichtag, 'dd.mm.YYYY') AS stichtag
                        FROM
                            avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
                      )
WHERE
    route_id NOT IN (
        SELECT
            route_id
        FROM
            trips
    )
;
