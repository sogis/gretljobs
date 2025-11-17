-- Summe ungewichtete Abfahrten pro Haltestelle und Linie
DELETE FROM avt_oevkov_${currentYear}_v1.auswertung_auswertung_gtfs
;

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
        -- exception_type=1: Der Fahrbetrieb wurde für das angegebene Datum in gtfs_calendar_dates hinzugefügt.
        -- exception_type=2: Der Fahrbetrieb wurde für das angegebene Datum in gtfs_calendar_dates entfernt.
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
    ),
    abfahrten AS (
        SELECT
            stop.stop_name,
            linie.linienname,
            agency.agency_id,
            agency.unternehmer,
            route.route_id,
            route.route_type,
            route.route_desc,
            trip.trip_id,
            trip.trip_headsign,
            stoptime.pickup_type,
            count(departure_time) AS gtfs_count,
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
            trip_headsign <> stop_name
        AND
            -- Regulärer Zustieg
            (pickup_type = 0 OR pickup_type IS NULL)
        AND
            trip.trip_id IN (
                SELECT
                    trip_id
                FROM
                    alle_trips_stichtag
            )
        AND
            -- diese Unternehmen fahren offizielle Haltestellen an, werden aber im OEVKOV nicht berücksichtigt (Stand 2018)
            agency.unternehmer NOT IN (
                'Domo Swiss Express AG',
                'Events / Manifestations / Eventi'
            )
        AND
           route_desc IN (
                'B',        -- Bus 
                'BN',       -- Nachtbus
                'BP',       -- PanoramaBus
                'EXB',      -- Expressbus
                'KB',       -- Kleinbus
                'NFB',      -- Niederflur-Bus
                'NFT',      -- Niederflur-Tram
                'R',        -- Regio
                'RB',       -- Regionalbahn
                'RE',       -- RegioExpress
                'S',        -- S-Bahn
                'SN',       -- Nacht-S-Bahn
                'T',        -- Tram
                'TER'       -- Train Express Regional
           )
        GROUP BY
            stop.stop_name,
            linie.linienname,
            agency.agency_id,
            agency.unternehmer,
            route.route_id,
            route.route_type,
            route_desc,
            trip.trip_id,
            trip_headsign,
            pickup_type,
            verkehrsmittel
    )

    -- Abfahrten der meisten Haltestellen ausser den Ausnahmen unten
    SELECT
        stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count) AS gtfs_count,
        verkehrsmittel
    FROM
        abfahrten
    -- ************************************ Ausnahmen *******************************************
    -- gewisse Bahnhöfe müssen separat behandelt werden wegen der Zuordnung der route_id zu den OeV-Linien im AVT
    WHERE
        stop_name NOT IN (
            'Däniken SO',
            'Dulliken',
            'Murgenthal',
            'Olten',
            'Schönenwerd SO'
        )
    -- ***************************** Ende der Ausnahmen *********************************
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

    -- ab hier werden  Bahnhöfe behandelt, die wegen mehrfacher Zuordnung der route_id
    -- zu den OeV-Liniennach trip_headsign aufgeteilt werden müssen

    UNION ALL

    -- Bahnhof Olten: L410 Biel - Olten
    SELECT
        stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count) AS gtfs_count,
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        stop_name = 'Olten'
    AND
        substring(linienname from 1 for 4) = 'L410'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        gtfs_count,
        unternehmer,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: L450 Olten - Bern
    SELECT
        stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        stop_name = 'Olten'
    AND
        trip_headsign IN ('Bern', 'Langenthal')
    AND
        substring(linienname from 1 for 4) = 'L450'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: L500 Olten - Basel (S3)
    SELECT
        stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        stop_name = 'Olten'
    AND
       linienname = 'L500 Olten - Basel (S3)'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: L503 Olten - Sissach (S9)
    SELECT
        stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        stop_name = 'Olten'
    AND
        linienname = 'L503 Olten - Sissach (S9)'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: L510 Olten - Luzern (RE)
    SELECT
        stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        stop_name = 'Olten'
    AND
        trip_headsign = 'Luzern'
    AND
        substring(linienname from 1 for 4) = 'L510'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: L510 Olten - Zofingen/Sursee (S29)
    SELECT
        stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        stop_name = 'Olten'
    AND
        linienname = 'L510 Olten - Zofingen/Sursee (S29)'
    AND
       trip_headsign IN ('Sursee', 'Zofingen')
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL
    
    -- Bahnhof Olten
    -- L650 Olten - Baden (S23)
    -- L650 Olten - Rotkreuz (S26)
    -- L650 Olten - Wettingen - Zürich HB (RE12)
    -- L650 Olten - Aarau - Turgi (S29)
    SELECT
        stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        stop_name = 'Olten'
    AND
        trip_headsign IN (
            'Baden',
            'Rotkreuz',
            'Turgi',
            'Wettingen',
            'Zürich HB',
            'Brugg AG',
            'Aarau',
            'Muri AG'
       )
    AND
        substring(linienname from 1 for 4) = 'L650'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel
 
    UNION ALL
    
    -- Bahnhof Dulliken, Däniken SO, Schönenwerd SO
    -- L650 Olten - Baden (S23)
    -- L650 Olten - Rotkreuz (S26)
    -- L650 Olten - Wettingen - Zürich HB (RE12)
    -- L650 Olten - Aarau - Turgi (S29)
    SELECT
        stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        stop_name IN ('Dulliken', 'Däniken SO', 'Schönenwerd SO')
    AND
        substring(linienname from 1 for 4) = 'L650'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel
 
    UNION ALL
    
    -- Bahnhof Murgenthal
    -- 450 Olten-Zürich R, S und 450 Bern - Olten haben die gleiche route_id!
    SELECT
    stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count) AS gtfs_count,
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        stop_name = 'Murgenthal'
    AND
        substring(linienname from 1 for 4) = 'L450'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        gtfs_count,
        unternehmer,
        verkehrsmittel
    )
;
