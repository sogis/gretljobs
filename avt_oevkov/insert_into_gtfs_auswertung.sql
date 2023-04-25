DELETE FROM avt_oevkov_${currentYear}_v1.auswertung_auswertung_gtfs
;

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
-- *********************************************************************************
-- Diesen Block bis Markierung unten kopieren und in SQL abfahrten_oev_guete.sql 
-- einfügen (Block zusätzliche Bedingung für OeV-Güteklassen auskommentieren
-- *********************************************************************************

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
                         avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten), 'Day')))) = 'thursday'
                THEN 
                    gtfs_calendar.thursday
            WHEN
                (SELECT BTRIM(lower(to_char((
                     SELECT
                         stichtag
                     FROM
                          avt_oevkov_${currentYear}_v1.sachdaten_oevkov_daten), 'Day')))) = 'tuesday'
                THEN
                    gtfs_calendar.tuesday
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
                WHEN route_desc = 'B'
                     THEN 1
                WHEN route_desc IN ('RE', 'IR', 'IC')
                     THEN 2
                WHEN route_desc IN ('R', 'S', 'SN', 'T')
                    THEN 3
            END AS verkehrsmittel
        FROM
            avt_oevkov_${currentYear}_v1.gtfs_agency AS agency, 
            avt_oevkov_${currentYear}_v1.gtfs_route AS route,
            avt_oevkov_${currentYear}_v1.gtfs_trip AS trip,
            avt_oevkov_${currentYear}_v1.gtfs_stoptime AS stoptime,
            avt_oevkov_${currentYear}_v1.gtfs_stop AS stop,
            avt_oevkov_${currentYear}_v1.sachdaten_linie_route AS linie 
        WHERE
            (
            trip.service_id IN (
                SELECT
                    service_id
                FROM
                    calendar
                WHERE dayofweek = 1
            )
            OR
            trip.service_id IN (
                SELECT
                    service_id
                FROM
                    exception
                WHERE
                    exception_type = 1
               )
            )
        AND
            trip.service_id NOT IN (
                SELECT
                    service_id
                FROM
                    exception
                WHERE
                    exception_type = 2
        )
        AND
-- diese Haltestellen werden nur wegen Spezialfall Bahnhof Olten benötigt
            stop.stop_name NOT IN (
                'Aarau',
                'Langenthal',
                'Zofingen'
            )
        AND
-- diese Unternehmen fahren offizielle Haltestellen an, werden aber im OEVKOV nicht berücksichtigt
            agency.unternehmer NOT IN (
                'Domo Swiss Express AG'
            )
        AND
            agency.agency_id::text = route.agency_id
        AND
            route.route_id = trip.route_id
        AND
            route.route_id = linie.route_id
        AND
            stop.stop_id = stoptime.stop_id
        AND
            stoptime.trip_id = trip.trip_id
--         AND
--             trip_headsign <> stop.stop_name
        AND
            pickup_type = 0
        AND
           route_desc IN (
               'IC',
               'EuroCity',
               'IR',
               'RE',
               'R',
               'S',
               'SN',
               'B',
               'T'
           )
/*
-- ****************** zusätzliche Bedingung für OeV-Güteklassen auskommentieren ********************
        AND
            substring(departure_time from 1 for 2) IN
                ('06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19')
--**************** *********************************************************************************
*/
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
 

-- die meisten Haltestellen
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
       trip_headsign <> stop_name
       
-- *********** hier kommen die Ausnahmen, die werden weiter unten abgehandelt ***********
    
-- gewisse Bahnhöfe müssen separat behandelt werden wegen der Zuordnung zu den Linien
    AND
        stop_name NOT IN (
            'Däniken',
            'Dornach-Arlesheim',
            'Dulliken',
            'Grenchen Nord',
            'Grenchen Süd',
            'Murgenthal',
            'Oensingen',
            'Olten',
            'Schönenwerd SO',
            'Solothurn'
        )
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

-- ***************************** Ende der Ausnahmen *********************************

-- **************************************************************************************
-- ab hier werden die Bahnhöfe und andere Knotenpunkte behandelt,
-- wegen Aufteilung in Linien beim OEVKOV

    UNION ALL
    
-- Bahnhof Solothurn
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
       trip_headsign <> stop_name
    AND
        stop_name = 'Solothurn'
    AND
        substring(linienname from 1 for 4) IN
            ('L308', 'L344', 'L410', 'L411', 'L413')
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL

--   Bahnhof Oensingen: L410 Biel - Olten
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Oensingen'
    AND
        substring(linienname from 1 for 4) IN ('L410', 'L412', 'L413')
    GROUP BY
        stop_name,
        route_id,
        linienname,
        gtfs_count,
        unternehmer,
        verkehrsmittel
        
    UNION ALL

--   Bahnhof Olten: L410 Biel - Olten
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
         trip_headsign IN (
             'Biel/Bienne',
             'Genève-Aéroport',
             'Langendorf',
             'Lausanne',
             'Lommiswil',
             'Morges',
             'Oensingen',
             'Solothurn'
         )
    AND
        substring(linienname from 1 for 4) = 'L410'
    AND
        trip_id IN (
            SELECT
                alle_trips_stichtag.trip_id
            FROM
                alle_trips_stichtag,
                avt_oevkov_${currentYear}_v1.gtfs_route AS route_einschraenkung,
                avt_oevkov_${currentYear}_v1.gtfs_stop AS stop_einschraenkung,
                avt_oevkov_${currentYear}_v1.gtfs_stoptime AS stoptime_einschraenkung
           WHERE
               stop_einschraenkung.stop_name IN ('Solothurn', 'Oensingen')
           AND
               stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
           AND
               stoptime_einschraenkung.trip_id = alle_trips_stichtag.trip_id
         )
    GROUP BY
        stop_name,
        route_id,
        linienname,
        gtfs_count,
        unternehmer,
        verkehrsmittel

    UNION ALL

-- Bahnhof Olten:  L450 Olten - Bern
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        trip_headsign IN ('Bern', 'Langenthal')
    AND
        substring(linienname from 1 for 4) = 'L450'
    AND
        trip_id IN (
            SELECT
                alle_trips_stichtag.trip_id
            FROM
                alle_trips_stichtag,
                avt_oevkov_${currentYear}_v1.gtfs_route AS route_einschraenkung,
                avt_oevkov_${currentYear}_v1.gtfs_stop AS stop_einschraenkung,
                avt_oevkov_${currentYear}_v1.gtfs_stoptime AS stoptime_einschraenkung
           WHERE
               stop_einschraenkung.stop_name IN ('Langenthal')
           AND
               stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
           AND
               stoptime_einschraenkung.trip_id = alle_trips_stichtag.trip_id
         )
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
        trip_headsign <> stop_name
    AND
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
        trip_headsign <> stop_name
    AND
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
        trip_headsign <> stop_name
    AND
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
        trip_headsign <> stop_name
    AND
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        trip_headsign = 'Luzern'
    AND
        substring(linienname from 1 for 4) = 'L510'
    AND
        route_desc IN ('RE', 'IR')
    AND
        trip_id IN (
            SELECT
                alle_trips_stichtag.trip_id 
            FROM 
                alle_trips_stichtag,
                avt_oevkov_${currentYear}_v1.gtfs_route AS route_einschraenkung,
                avt_oevkov_${currentYear}_v1.gtfs_stop AS stop_einschraenkung,
                avt_oevkov_${currentYear}_v1.gtfs_stoptime AS stoptime_einschraenkung
            WHERE
                stop_einschraenkung.stop_name = 'Zofingen'
            AND
                trip_headsign = 'Luzern'
            AND
                stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
            AND
                stoptime_einschraenkung.trip_id = alle_trips_stichtag.trip_id
            AND
                route_desc IN ('RE', 'IR')
        )
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

     UNION ALL

-- Bahnhof Olten: L650 Olten - Zürich HB (IC/IR/RE)
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        trip_headsign IN (
            'Baden',
            'Chur',
            'Romanshorn',
            'Rorschach',
            'Rotkreuz',
            'St. Gallen',
            'Turgi',
            'Wettingen',
            'Zürich Flughafen',
            'Zürich HB'
        )
    AND
        substring(linienname from 1 for 4) = 'L650'
    AND
        linienname <> 'L650 Olten - Turgi (S29)'
    AND
        trip_id IN (
            SELECT
                alle_trips_stichtag.trip_id 
            FROM
                alle_trips_stichtag,
                avt_oevkov_${currentYear}_v1.gtfs_route AS route_einschraenkung,
                avt_oevkov_${currentYear}_v1.gtfs_stop AS stop_einschraenkung,
                avt_oevkov_${currentYear}_v1.gtfs_stoptime AS stoptime_einschraenkung
              WHERE
                  stop_einschraenkung.stop_name = 'Aarau'
              AND
                  stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
              AND
                  stoptime_einschraenkung.trip_id = alle_trips_stichtag.trip_id
        )
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL

-- Bahnhof Dulliken:
-- (650 Olten-Zürich R, S und 450 Bern - Olten haben die gleichen route_ids!
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Dulliken'
    AND
        substring(linienname from 1 for 4) = 'L650'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        gtfs_count,
        unternehmer,
        verkehrsmittel

    UNION ALL

-- Bahnhof Däniken
-- (650 Olten-Zürich R, S und 450 Bern - Olten haben die gleichen route_ids!
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Däniken'
    AND
        substring(linienname from 1 for 4) = 'L650'        
    GROUP BY
        stop_name,
        route_id,
        linienname,
        gtfs_count,
        unternehmer,
        verkehrsmittel

     UNION ALL

-- Bahnhof Schönenwerd
-- (650 Olten-Zürich R, S und 450 Bern - Olten haben die gleichen route_ids!
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Schönenwerd SO'
    AND
        substring(linienname from 1 for 4) = 'L650'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        gtfs_count,
        unternehmer,
        verkehrsmittel
        
    UNION ALL

-- Bahnhof Grenchen Süd
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Grenchen Süd'
    AND
        substring(linienname from 1 for 4) = 'L410'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

   UNION ALL

-- Bahnhof Murgenthal
-- (650 Olten-Zürich R, S und 450 Bern - Olten haben die gleichen route_ids!
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
        trip_headsign <> stop_name
    AND
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

     UNION ALL

-- Bahnhof Dornach-Arlesheim:
-- 230 Biel - Delémont und 500 Basel-Olten S
-- haben die gleiche route_id = 4-3-j19-1 
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Dornach-Arlesheim'
    AND
        linienname = 'L230 Basel - Delémont (S3)'
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

    UNION ALL

-- Bahnhof Grenchen Nord
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
        trip_headsign <> stop_name
    AND
        stop_name = 'Grenchen Nord'
    AND
        route_desc = 'RE'              -- InterCity werden nicht gezählt
    GROUP BY
        stop_name,
        route_id,
        linienname,
        unternehmer,
        verkehrsmittel

-- *********************************************************************************
--                     Ende Block für abfahrten_oev_guete.sql
-- *********************************************************************************
)
;
