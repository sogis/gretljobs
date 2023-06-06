-- Summe ungewichtete Abfahrten pro Haltestelle und Linie 
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
                -- Bus
                WHEN route_desc IN ('B', 'BN', 'BP', 'EXB', 'KB', 'NFB')
                     THEN 1
                -- Regionalverkehr
                WHEN route_desc IN ('NFT', 'R', 'RB', 'RE', 'S', 'SN', 'T', 'TER')
                     THEN 3
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
        -- diese Haltestellen werden nur wegen Spezialfall Bahnhof Olten benötigt,
        -- da nur die Fahrten zählen, welche ab Olten in diesen Bahnhöfen anhalten
            stop.stop_name NOT IN (
                'Aarau',
                'Langenthal',
                'Zofingen'
            )
        AND
        -- diese Unternehmen fahren offizielle Haltestellen an, werden aber im OEVKOV nicht berücksichtigt (2018)
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

-- die meisten Haltestellen ausser die Ausnahmen
    SELECT
        stop_name,
        route_id,
        linienname,
        unternehmer,
        sum(gtfs_count) AS gtfs_count,
        verkehrsmittel
    FROM
        abfahrten
-- *********** hier kommen die Ausnahmen, die werden weiter unten abgehandelt ***********
    -- gewisse Bahnhöfe müssen separat behandelt werden wegen der Zuordnung zu den Linien im AVT
    WHERE
        stop_name NOT IN (
            'Däniken SO',
            --'Dornach-Arlesheim',
            'Dulliken',
            --'Grenchen Nord',
            --'Grenchen Süd',
            'Murgenthal',
            --'Oensingen',
            'Olten',
            'Schönenwerd SO'
            --'Solothurn'
        )
-- ***************************** Ende der Ausnahmen *********************************
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

-- *********************************************************************************
-- ab hier werden die Bahnhöfe und andere Knotenpunkte behandelt,
-- wegen dem fehlenden Attribut "fahrplanfeld" muss die Aufteilung in Linien separat gemacht werden

    --UNION ALL

---- Bahnhof Solothurn
---- wegen Linienbezeichnung: L410 Olten - Biel (IC5) und
---- L650 Olten - Zürich HB (IC5) haben die gleiche route_id
    --SELECT
        --stop_name,
        --route_id,
        --linienname,
        --unternehmer,
        --sum(gtfs_count),
        --verkehrsmittel
    --FROM
        --abfahrten
    --WHERE
       --stop_name = 'Solothurn'
    --AND
        --substring(linienname from 1 for 4) NOT IN ('L650')
    --GROUP BY
        --stop_name,
        --route_id,
        --linienname,
        --unternehmer,
        --verkehrsmittel

    --UNION ALL

---- Bahnhof Oensingen: L410 Biel - Olten
---- wegen Linienbezeichnung: L410 Olten - Biel (IC5) und
---- L650 Olten - Zürich HB (IC5) haben die gleiche route_id
    --SELECT
        --stop_name,
        --route_id,
        --linienname,
        --unternehmer,
        --sum(gtfs_count) AS gtfs_count,
        --verkehrsmittel
    --FROM
        --abfahrten
    --WHERE
        --stop_name = 'Oensingen'
    --AND
        --substring(linienname from 1 for 4) NOT IN ('L650')
    --GROUP BY
        --stop_name,
        --route_id,
        --linienname,
        --gtfs_count,
        --unternehmer,
        --verkehrsmittel

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
         trip_headsign IN (
             'Biel/Bienne',
             'Langendorf',
             'Lommiswil',
             'Oensingen',
             'Solothurn'
         )
    AND
        substring(linienname from 1 for 4) = 'L410'
    --AND
        --trip_id IN (
            --SELECT
                --alle_trips_stichtag.trip_id
            --FROM
                --alle_trips_stichtag
                --LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_stoptime AS stoptime_einschraenkung
                    --ON stoptime_einschraenkung.trip_id = alle_trips_stichtag.trip_id
                --LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_stop AS stop_einschraenkung
                    --ON stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
           --WHERE
               --stop_einschraenkung.stop_name IN ('Solothurn', 'Oensingen')
         --)
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
    ----AND
        ------ Bedingung, dass Stop in Langenthal
        ----trip_id IN (
            ----SELECT
                ----alle_trips_stichtag.trip_id
            ----FROM
                ----alle_trips_stichtag
                ----LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_stoptime AS stoptime_einschraenkung
                    ----ON stoptime_einschraenkung.trip_id = alle_trips_stichtag.trip_id
                ----LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_stop AS stop_einschraenkung
                    ----ON stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
           ----WHERE
               ----stop_einschraenkung.stop_name IN ('Langenthal')
         ----)
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

-- Bahnhof Olten: L650 Turgi - Sursee (S29)
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
        linienname = 'L650 Olten - Turgi (S29)'
    AND
       trip_headsign IN ('Brugg AG', 'Turgi')
    GROUP BY
        stop_name,
        route_id,
        trip_headsign,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL

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
        trip_headsign,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL

-- Bahnhof Olten: L510 Olten - Luzern (IR/RE), RegioExpress zählt hier zu R
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
    AND
        route_desc = 'RE'
    AND
        -- Bedingung Halt in Zofingen
        trip_id IN (
            SELECT
                alle_trips_stichtag.trip_id
            FROM
                alle_trips_stichtag
                LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_stoptime AS stoptime_einschraenkung
                    ON stoptime_einschraenkung.trip_id = alle_trips_stichtag.trip_id
                LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_stop AS stop_einschraenkung
                    ON stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
            WHERE
                stop_einschraenkung.stop_name = 'Zofingen'
            AND
                trip_headsign = 'Luzern'
            AND
                route_desc = 'RE'
        )
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

     UNION ALL

-- Bahnhof Olten: L650 Olten - Zürich HB (RE)
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
            'Wettingen'
            --'Zürich HB'
        )
    AND
        substring(linienname from 1 for 4) = 'L650'
    AND
        linienname <> 'L650 Olten - Turgi (S29)'
    --AND
        ---- Bedingung Halt in Aarau
        --trip_id IN (
            --SELECT
                --alle_trips_stichtag.trip_id
            --FROM
                --alle_trips_stichtag
                --LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_stoptime AS stoptime_einschraenkung
                    --ON stoptime_einschraenkung.trip_id = alle_trips_stichtag.trip_id
                --LEFT JOIN avt_oevkov_${currentYear}_v1.gtfs_stop AS stop_einschraenkung
                    --ON stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
              --WHERE
                  --stop_einschraenkung.stop_name = 'Aarau'
        --)
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL

-- Däniken, Dulliken, Schönenwerd:
-- 650 Olten-Zürich R, S und 450 Bern - Olten haben die gleiche route_id!
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
        stop_name IN ('Dulliken', 'Däniken SO', 'Schönenwerd SO')
    AND
        substring(linienname from 1 for 4) = 'L650'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        gtfs_count,
        unternehmer,
        verkehrsmittel

    --UNION ALL

---- Bahnhof Grenchen Süd
---- wegen Linienbezeichnung: L410 Olten - Biel (IC5) und
---- L650 Olten - Zürich HB (IC5) haben die gleiche route_id
    --SELECT
        --stop_name,
        --route_id,
        --linienname,
        --unternehmer,
        --sum(gtfs_count),
        --verkehrsmittel
    --FROM
        --abfahrten
    --WHERE
        --stop_name = 'Grenchen Süd'
    --AND
        --substring(linienname from 1 for 4) = 'L410'
    --GROUP BY
        --stop_name,
        --route_id,
        --linienname,
        --unternehmer,
        --verkehrsmittel

    --UNION ALL

---- Bahnhof Grenchen Nord
    --SELECT
        --stop_name,
        --route_id,
        --linienname,
        --unternehmer,
        --sum(gtfs_count),
        --verkehrsmittel
    --FROM
        --abfahrten
    --WHERE
        --stop_name = 'Grenchen Nord'
    --AND
        --route_desc = 'RE'
    --GROUP BY
        --stop_name,
        --route_id,
        --linienname,
        --unternehmer,
        --verkehrsmittel

   UNION ALL

-- Bahnhof Murgenthal
-- 650 Olten-Zürich R, S und 450 Bern - Olten haben die gleiche route_id!
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

     --UNION ALL

---- Bahnhof Dornach-Arlesheim:
---- 230 Biel - Delémont und 500 Basel-Olten S
---- haben die gleiche route_id
    --SELECT
        --stop_name,
        --route_id,
        --linienname,
        --unternehmer,
        --sum(gtfs_count),
        --verkehrsmittel
    --FROM
        --abfahrten
    --WHERE
        --stop_name = 'Dornach-Arlesheim'
    ----------------------------------------------------------------------------------------------------AND
        ----------------------------------------------------------------------------------------------------substring(linienname from 1 for 4) = 'L230'
    --GROUP BY
        --stop_name,
        --route_id,
        --linienname,
        --unternehmer,
        --verkehrsmittel
    )
;
