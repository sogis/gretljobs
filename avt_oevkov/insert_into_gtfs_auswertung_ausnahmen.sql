-- Alle  Haltestellen, die wegen pickup_type = 0 herausfallen
-- oder am Stichtag 0 Abfahrten haben
INSERT INTO
     avt_oevkov_${currentYear}_v1.auswertung_auswertung_gtfs
     (
          haltestellenname,
          route_id,
          linie,
          unternehmer,
          anzahl_abfahrten_linie,
          verkehrsmittel
     )
     (
     WITH calendar AS (
     -- dayofweek (1=fährt, 0=fährt nicht) am Stichtag
        SELECT
            service_id,
        CASE
            WHEN
                (SELECT BTRIM(lower(to_char((
                     SELECT
                         stichtag
                     FROM
                         avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten), 'Day')))) = 'friday'
                THEN
                    gtfs_calendar.friday
        END AS dayofweek
        FROM
            avt_oevkov_${currentYear}_v1.gtfs_calendar
    ),
    exception AS (
        -- exception_type=1: Der Fahrbetrieb wurde für das angegebene Datum hinzugefügt.
        -- exception_type=2: Der Fahrbetrieb wurde für das angegebene Datum entfernt.
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
                         avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten
                    )
    ),
    alle_trips_stichtag AS (
        SELECT
            trip_id 
        FROM 
            avt_oevkov_${currentYear}_v1.gtfs_trip
        WHERE
            (
            gtfs_trip.service_id IN (
                SELECT
                    service_id
                FROM
                    calendar
                WHERE
                    dayofweek = 1
            )
            OR
                gtfs_trip.service_id IN (
                    SELECT
                        service_id
                    FROM
                        exception
                    WHERE
                        exception_type = 1
                )
            )
        AND
            gtfs_trip.service_id NOT IN (
                SELECT
                    service_id
                FROM
                    exception
                WHERE
                    exception_type = 2
            )
    )
    SELECT
         stop_name,
         route.route_id,
         linie.linienname,
         agency.unternehmer,
         0 as gtfs_count,
        CASE
            WHEN route_desc IN ('B', 'BN', 'BP', 'EXB', 'KB', 'NFB')
                THEN 'Bus'
            WHEN route_desc IN ('NFT', 'T')
                THEN 'Tram'
            WHEN route_desc IN ('R', 'RB', 'RE', 'S', 'SN', 'TER')
                THEN 'Bahn'
            END AS verkehrsmittel
     FROM
            avt_oevkov_${currentYear}_v1.gtfs_agency AS agency
            LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_route AS route
                ON agency.agency_id::text = route.agency_id
            LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_trip AS trip
                ON route.route_id = trip.route_id
            LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_stoptime AS stoptime
                ON stoptime.trip_id = trip.trip_id
            LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_stop AS stop
                ON stop.stop_id = stoptime.stop_id
            LEFT JOIN avt_oevkov_${currentYear}_v1.sachdaten_linie_route AS linie
                ON route.route_id = linie.route_id
     WHERE
         trip.trip_id IN (
            SELECT
                alle_trips_stichtag.trip_id
            FROM
                alle_trips_stichtag
        )
    AND
        stop.stop_name||linienname NOT IN (
            SELECT
                haltestellenname||linie
            FROM 
                avt_oevkov_2023_v1.auswertung_auswertung_gtfs
    )
    AND
        (pickup_type = 0 OR pickup_type IS NULL)
    AND
        trip_headsign <> stop_name
    AND
        route_desc IN ('B', 'BN', 'BP', 'EXB', 'KB', 'NFB', 'NFT', 'R', 'RB', 'RE', 'S', 'SN', 'T', 'TER')
    GROUP BY
        stop.stop_name,
        route.route_id,
        linie.linienname,
        agency.unternehmer,
        verkehrsmittel
    )
;

