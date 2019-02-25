-- Summe ungewichtete Abfahrten pro Haltestelle und Linie
BEGIN;
TRUNCATE TABLE avt_oevkov_${currentYear}.auswertung_auswertung_gtfs;
INSERT INTO
    avt_oevkov_${currentYear}.auswertung_auswertung_gtfs
     (
     haltestellenname,
     linie,
     unternehmer,
     anzahl_abfahrten_linie,
     verkehrsmittel
     )
     (
    WITH calendar AS (
        SELECT
            service_id,
        CASE
        WHEN (SELECT BTRIM(lower(to_char((
                         SELECT
                                 stichtag
                             FROM
                                    avt_oevkov_${currentYear}.sachdaten_oevkov_daten), 'Day')))) = 'thursday'
             THEN thursday
        WHEN (SELECT BTRIM(lower(to_char((
                         SELECT
                                 stichtag
                             FROM
                                    avt_oevkov_${currentYear}.sachdaten_oevkov_daten), 'Day')))) = 'tuesday'
             THEN tuesday
        END AS dayofweek
        FROM
            avt_oevkov_${currentYear}.gtfs_calendar
    ),
    exception AS (
        SELECT
            service_id,
            exception_type
        FROM
            avt_oevkov_${currentYear}.gtfs_calendar_dates
        WHERE
            datum = (
                            SELECT
                                stichtag
                            FROM
                                avt_oevkov_${currentYear}.sachdaten_oevkov_daten)
    ),
    abfahrten AS (
        SELECT
            stop.stop_name,
            linie.linienname,
            agency.agency_id,
            agency.agency_name,
            route.route_id,
            route.route_type,
            route.route_desc,
            trip.trip_id,
            trip.trip_headsign,
            stoptime.pickup_type,
            count(departure_time) AS gtfs_count,
            CASE                                                                                                         -- Bedarfsangebot????
                WHEN route_desc = 'Bus'
                     THEN 1                                                                                             -- Bus (200 ICB? weggelassen)
                WHEN route_desc IN ('RegioExpress', 'InterRegio', 'Intercity')
                     THEN 2                                                                                             -- Railjet, Schnellzug, Eurocity, ICE, TGV, Eurostar, InterRegio (105 Nachtzug weggelassen)
                WHEN route_desc IN ('Regionalzug', 'S-Bahn', 'Tram')
                    THEN 3
            END AS verkehrsmittel
        FROM
            avt_oevkov_${currentYear}.gtfs_agency AS agency,
            avt_oevkov_${currentYear}.gtfs_route AS route,
            avt_oevkov_${currentYear}.gtfs_trip AS trip,
            avt_oevkov_${currentYear}.gtfs_stoptime AS stoptime,
            avt_oevkov_${currentYear}.gtfs_stop AS stop,
            avt_oevkov_${currentYear}.sachdaten_linie_route AS linie
--             avt_oevkov_${currentYear}.so_geodaten_gemeindegrenzen As gemeindegrenze             -- Gemeindegrenze nur für Einschränkung, später Daten so aufbereiten dass nur die erforderlichen Haltestellen vorhanden sind 
        WHERE                                                                                                                       -- > viel schneller so
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
--         AND
--             stop.geometrie && gemeindegrenze.geometrie
--         AND
--             ST_Contains(gemeindegrenze.geometrie, stop.geometrie)
        AND
            stop.stop_name NOT IN (
                'Aarau', 'Langenthal', 'Murgenthal', 'Zofingen'
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
        -- AND
    --        trip_headsign <> stop.stop_name                                 -- liefert zuerst alle Abfahrten: wird das unten benötigt? 1 mal, wegen Dornach, Bahnhof'
        AND
            pickup_type = 0
        AND
           route_desc IN (
               'Intercity', 'ICE', 'InterRegio', 'RegioExpress',
               'Regionalzug', 'S-Bahn', 'Bus', 'Tram'
           )
        GROUP BY
            stop.stop_name,
            linie.linienname,
            agency.agency_id,
            agency.agency_name,
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
        linienname,
        agency_name,
        sum(gtfs_count) AS gtfs_count,
        verkehrsmittel
    FROM
        abfahrten
    WHERE
       trip_headsign <> stop_name
       
    -- **************************************************************** hier kommen die Ausnahmen, die werden unten abgehandelt ****************************************************************************************
    AND
        -- Bahnhöfe werden separat behandelt wegenZuordnung zu den LInien
        stop_name NOT IN (
            'Olten', 'Solothurn', 'Biberist RBS', 'Lohn-Lüterkofen', 'Oensingen', 'Dornach, Bahnhof', 'Grenchen Nord'
        )
    AND
        -- Linie 650 Olten - Zürich (RE/IR/ICN) und Linie 450 Bern - Olten (IR/RE) haben die gleichen route_ids!
        stop_name <> 'Dulliken'
    AND
        -- Linie 650 Olten - Zürich (RE/IR/ICN) und Linie 450 Bern - Olten (IR/RE) haben die gleichen route_ids!
        stop_name <> 'Däniken'
    AND
        -- Linie 230 Biel - Delémont (RE/ICN) und Linie 500 Olten - Basel (S3) haben die gleichen route_ids!
        stop_name <> 'Dornach-Arlesheim' 
    AND
         -- Linie 650 Olten - Zürich (RE/IR/ICN) und Linie 410 Biel - Olten (ICN) haben die gleichen route_ids!
         stop_name <> 'Grenchen Süd'
    AND
        -- Linie 650 Olten - Zürich (RE/IR/ICN) und Linie 450 Bern - Olten (IR/RE) haben die gleichen route_ids!
        stop_name <> 'Schönenwerd SO'
    AND
         -- Linie 650 Olten - Zürich (RE/IR/ICN) und Linie 450 Bern - Olten (IR/RE) haben die gleichen route_ids!
         stop_name <> 'Murgenthal'
    AND
        -- wegen Unterscheidung Flüh Bahnhof (Tram 10) und Flüh, Bahnhof (Bus),  Flüh Station fehlt gtfs
        stop_name <> 'Flüh, Bahnhof' 
    -- **************************************************************** Ende der Ausnahmen ***********************************************************************************************
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    --     Alle Haltestellen ergänzen,welche ausserhalb des Kantons liegen, aber einer
    --     Solothurner Gemeinde angerechnet werden, ausser die, welche unten als Speziallfall  behandelt werden
    --     Die Zuordnung zu einer Gemeinde erfolgt über die Tabelle avt_oevkov_${currentYear}.sachdaten_haltestelle_anrechnung,
    --     welche durch die Abt. Oev festgelegt wird
    SELECT  
        stop.stop_name,
        linie.linienname,
        agency.agency_name,
        count(departure_time) AS gtfs_count,
        CASE                                                                                                                             -- Bedarfsangebot???
            WHEN route_desc= 'Bus'
                 THEN 1                                                                                                             -- Bus (200 ICB? weggelassen)
            WHEN route_desc IN ('RegioExpress', 'InterRegio', 'Intercity')
                 THEN 2                                                                                                             -- Intercity, Railjet, Schnellzug, Eurocity, ICE, TGV, Eurostar, InterRegio (105 Nachtzug weggelassen)
            WHEN route_desc IN ('Regionalzug', 'S-Bahn',  'Tram')
                THEN 3
        END AS verkehrsmittel
    FROM avt_oevkov_${currentYear}.gtfs_agency AS agency,
        avt_oevkov_${currentYear}.gtfs_route AS route,
        avt_oevkov_${currentYear}.gtfs_trip AS trip,
        avt_oevkov_${currentYear}.gtfs_stoptime AS stoptime,
        avt_oevkov_${currentYear}.gtfs_stop AS stop,
        avt_oevkov_${currentYear}.sachdaten_linie_route AS linie
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
        stop.stop_name IN (
            'Arlesheim, Obesunne', 'Erlinsbach, Oberdorf', 'Erlinsbach, Sagi',
            'Gänsbrunnen', 'Gänsbrunnen, Bahnhof', 'Nuglar, Neunuglar', 
             'Niederbipp Industrie', 'Walterswil-Striegel'                                                                  --   'Wisen (S=), Adlike-Rank' zählt definitiv nicht oder doch?????????????????????????????'''
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
    AND
        trip_headsign <> stop.stop_name
    AND
        pickup_type = 0
    AND
       route_desc IN (
           'Intercity', 'ICE', 'InterRegio', 'RegioExpress',
           'Regionalzug', 'S-Bahn', 'Bus', 'Tram'
       )
    GROUP BY
        stop.stop_name,
        linie.linienname,
        agency.agency_name,
        verkehrsmittel

-- **************************************************************************************
-- ab hier werden die Bahnhöfe und andere Knotenpunkte behandelt, wegen Aufteilung in Linien
    UNION ALL

     -- Bahnhof Solothurn: Linie - 410 Biel-Olten (RE)
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
       trip_headsign <> stop_name
    AND
        stop_name = 'Solothurn'
    AND
        agency_name = 'Schweizerische Bundesbahnen SBB'
    AND
        linienname = 'Linie 410 Biel - Olten (RE)'
    AND
        route_desc IN ('Regionalzug', 'S-Bahn')
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Solothurn: Linie - 410 Biel-Olten (ICN)
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Solothurn'
    AND
        linienname = 'Linie 410 Biel - Olten (ICN)'
    AND
        route_desc = 'Intercity'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Solothurn: Linie 411 Solothurn - Moutier
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Solothurn'
    AND
        linienname = 'Linie 411 Solothurn - Moutier'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

     -- Bahnhof Solothurn: Linie 304.1 Burgdorf - Solothurn
    SELECT
       stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Solothurn'
    AND
        agency_name = 'BLS AG (bls)' 
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Solothurn: Linie 413 Solothurn - Langenthal
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Solothurn'
    AND
        agency_name = 'Aare Seeland mobil (snb)'
    AND linienname = 'Linie 413 Solothurn - Langenthal'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Solothurn:  Linie 308 Bern - Solothurn
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        3 AS verkehrsmittel                                                                                            -- Speziallfall
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Solothurn'          
    AND
        agency_name = 'Regionalverkehr Bern-Solothurn'
    GROUP BY
        stop_name,
        linienname,
        agency_name
--         verkehrsmittel

    UNION ALL

     -- Biberist RBS Linie 308 Bern - Solothurn
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        3 AS verkehrsmittel                                                                                           -- Speziallfall
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Biberist RBS'          
    AND
        agency_name = 'Regionalverkehr Bern-Solothurn'
    GROUP BY
        stop_name,
        linienname,
        agency_name
--         verkehrsmittel

    UNION ALL

     -- Lohn-Lüterkofen Linie 308 Bern - Solothurn
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        3 AS verkehrsmittel                                                                                            -- Speziallfall
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Lohn-Lüterkofen'          
    AND
        agency_name = 'Regionalverkehr Bern-Solothurn'
    GROUP BY
        stop_name,
        linienname,
        agency_name
--         verkehrsmittel

    UNION ALL

    -- Bahnhof Oensingen
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Oensingen'
    AND
        linienname IN (
            'Linie 412 Oensingen - Balsthal',  'Linie 410 Biel - Olten (RE)', 
            'Linie 410 Biel - Olten (ICN)',  'Linie 413 Solothurn - Langenthal'
        )
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel
     
    UNION ALL

    -- Bahnhof Olten: Linie 410 Biel - Olten (RE)
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count) AS gtfs_count,
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        trip_headsign IN ('Biel/Bienne', 'Langendorf', 'Lommiswil', 'Oberdorf SO', 'Solothurn')
    AND
        route_desc = 'Regionalzug'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel
    
    UNION ALL
    
    -- Bahnhof Olten: Linie 410 Biel - Olten (ICN)
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        linienname = 'Linie 410 Biel - Olten (ICN)'                                    -- das muss zwingend stehen, weil und Linie 410 Biel - Olten (ICN) und Linie 650 Olten - Zürich (RE/IR/ICN
    AND                                                                                                    --  identische Route haben und unterschiedlich ausgewertet werden
        trip_headsign IN ('Biel/Bienne',  'Genève-Aéroport',  'Lausanne') 
   AND
        route_desc IN ('InterRegio', 'Intercity')
   GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel
    
   UNION ALL
    
    -- Bahnhof Olten: Linie 450 Langenthal - Olten (S23/S29)
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        linienname <> 'Linie 650 Olten - Aarau (S23/S26/S29)'
    AND
        trip_headsign IN ('Bern', 'Langenthal')
    AND
        route_desc IN ('Regionalzug', 'S-Bahn')
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel
    
    UNION ALL

 -- Bahnhof Olten: Linie 650 Olten - Zürich (RE/IR/ICN)          
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        linienname <> 'Linie 650 Olten - Zürich (RE/IR/ICN)'
    AND
        trip_headsign IN ('Bern', 'Langenthal')
    AND
        trip_id IN (
            SELECT trip_einschraenkung.trip_id                                                                   -- lässt sich nur so aufteilen!
        FROM
            avt_oevkov_${currentYear}.gtfs_route AS route_einschraenkung,
            avt_oevkov_${currentYear}.gtfs_trip AS trip_einschraenkung,
            avt_oevkov_${currentYear}.gtfs_stop AS stop_einschraenkung,
            avt_oevkov_${currentYear}.gtfs_stoptime AS stoptime_einschraenkung
       WHERE
           (trip_einschraenkung.service_id IN (
            SELECT
                service_id
            FROM
                calendar
            WHERE dayofweek = 1
           )
           OR trip_einschraenkung.service_id IN (
            SELECT
                service_id
            FROM
                exception
            WHERE
                exception_type = 1
                 )
            )
        AND
            trip_einschraenkung.service_id NOT IN (
            SELECT
                service_id
            FROM
                exception
            WHERE
                exception_type = 2
            )
         AND
            stop_einschraenkung.stop_name IN ('Langenthal')
         AND
            route_einschraenkung.route_id = trip_einschraenkung.route_id
         AND
            stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
         AND
            stoptime_einschraenkung.trip_id = trip_einschraenkung.trip_id
         AND
            route_desc IN ('RegioExpress', 'InterRegio')
         )
    AND
        route_desc IN ('RegioExpress', 'InterRegio')
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: Linie 500 Olten - Basel (S3)
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        linienname = 'Linie 500 Olten - Basel (S3)'
    AND
        (route_type = 106
        OR
        route_type = 400)
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

     UNION ALL

    -- Bahnhof Olten: Linie 503 Olten - Sissach (S9)
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
       trip_headsign = 'Sissach'
    AND
        (route_type = 106
        OR
        route_type = 400)
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: Linie 510 Olten - Sursee (S8)          RegioExpress zählt hier zu R       Achtung: verkehrsmittel wird hier fix eingegeben!!!
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        linienname = 'Linie 510 Olten - Sursee (S8)'
    AND
        route_desc IN ('Regionalzug', 'S-Bahn')
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    --- Bahnhof Olten: Linie 510 Olten - Luzern (IR/RE)          RegioExpress zählt hier zu R
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        2 AS verkehrsmittel                                                                                                    -- Achtung: verkehrsmittel wird hier fix eingegeben!!!
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        trip_headsign IN (
            'Brig', 'Chiasso', 'Domodossoloa (I)', 'Erstfeld', 'Lugano', 'Luzern'
        )
    AND
         linienname = 'Linie 510 Olten - Luzern (IR/RE)'                                              -- das muss zwingend stehen, weil route_id = 20-21-j19-1 für Olten-Basel und Olten-Luzern gilt, kann man das besser lösen?
    AND
        route_desc IN ('RegioExpress', 'InterRegio')
    AND
        trip_id IN (SELECT trip_einschraenkung.trip_id 
            FROM 
                avt_oevkov_${currentYear}.gtfs_route AS route_einschraenkung,
                avt_oevkov_${currentYear}.gtfs_trip AS trip_einschraenkung,
                avt_oevkov_${currentYear}.gtfs_stop AS stop_einschraenkung,
                avt_oevkov_${currentYear}.gtfs_stoptime AS stoptime_einschraenkung
            WHERE
                (trip_einschraenkung.service_id IN (
            SELECT
                service_id
            FROM
                calendar
            WHERE dayofweek = 1
           )
           OR trip_einschraenkung.service_id IN (
            SELECT
                service_id
            FROM
                exception
            WHERE
                exception_type = 1
                 )
            )
        AND
            trip_einschraenkung.service_id NOT IN (
            SELECT
                service_id
            FROM
                exception
            WHERE
                exception_type = 2
            )
             AND
                stop_einschraenkung.stop_name = 'Zofingen'
             AND
                trip_einschraenkung.trip_headsign <> 'Olten'
             AND
                trip_headsign IN ('Brig', 'Chiasso', 'Domodossoloa (I)', 'Erstfeld', 'Lugano', 'Luzern') 
             AND
                route_einschraenkung.route_id = trip_einschraenkung.route_id
             AND
                stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
             AND
                stoptime_einschraenkung.trip_id = trip_einschraenkung.trip_id
             AND
                route_desc IN ('RegioExpress', 'InterRegio')
             )
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: Linie 650 Olten - Aarau (S23/S26/S29)
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
         linienname = 'Linie 650 Olten - Aarau (S23/S26/S29)'
    AND
        trip_headsign IN ('Baden', 'Rotkreuz', 'Turgi')
    AND
        route_desc IN ('Regionalzug', 'S-Bahn')  
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: Linie 650 Olten - Zürich (RE/IR/ICN)
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        linienname = 'Linie 650 Olten - Zürich (RE/IR/ICN)'                                                                           -- das muss zwingend stehen, weil und 410 Olten - Solothurn - Biel und 650 Olten-Zürich R identische Route sind
    AND
        trip_headsign IN ('Romanshorn', 'ST. Gallen', 'Wettingen', 'Zürich Flughafen', 'Zürich HB')
    AND
        route_desc IN ('RegioExpress', 'InterRegio', 'Intercity')
    AND
        trip_id IN (SELECT trip_einschraenkung.trip_id 
            FROM 
                avt_oevkov_${currentYear}.gtfs_route AS route_einschraenkung,
                avt_oevkov_${currentYear}.gtfs_trip AS trip_einschraenkung,
                avt_oevkov_${currentYear}.gtfs_stop AS stop_einschraenkung,
                avt_oevkov_${currentYear}.gtfs_stoptime AS stoptime_einschraenkung
              WHERE
                (trip_einschraenkung.service_id IN (
            SELECT
                service_id
            FROM
                calendar
            WHERE dayofweek = 1
           )
           OR trip_einschraenkung.service_id IN (
            SELECT
                service_id
            FROM
                exception
            WHERE
                exception_type = 1
                 )
            )
        AND
            trip_einschraenkung.service_id NOT IN (
            SELECT
                service_id
            FROM
                exception
            WHERE
                exception_type = 2
            )
            AND
                stop_einschraenkung.stop_name = 'Aarau'
            AND
                trip_headsign IN ('Romanshorn', 'trip. Gallen', 'Wettingen', 'Zürich Flughafen', 'Zürich HB')
            AND
                route_einschraenkung.route_id = trip_einschraenkung.route_id
            AND
                stop_einschraenkung.stop_id = stoptime_einschraenkung.stop_id
            AND
                stoptime_einschraenkung.trip_id = trip_einschraenkung.trip_id
            AND
                route_desc IN ('RegioExpress', 'InterRegio', 'Intercity')
     )
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Dulliken: (650 Olten-Zürich R, S und 450 Bern - Olten haben die gleichen route_ids!
    -- S-Bahn zählen alle, RegioExpress nur die Abfahrten Richtung Olten!
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(sum),
        verkehrsmittel
    FROM (
        SELECT
            stop_name,
            'Linie 650 Olten - Aarau (S23/S26/S29)' AS linienname,
            agency_name,
            sum(gtfs_count),
            verkehrsmittel
        FROM
            abfahrten
        WHERE
            trip_headsign <> stop_name
        AND
            stop_name = 'Dulliken'
        AND
            route_desc IN ('Regionalzug', 'S-Bahn')
        AND
            linienname = 'Linie 650 Olten - Aarau (S23/S26/S29)'
        GROUP BY
            stop_name,
            linienname,
            agency_name,
            verkehrsmittel
        
        UNION

        -- Bahnhof Dulliken: S-Bahn zählen alle, RegioExpress nur die Abfahrten Richtung Olten!
        SELECT
            stop_name,
            'Linie 650 Olten - Zürich (RE/IR/ICN)' AS linienname,
            agency_name,
            sum(gtfs_count),
            2 AS verkehrsmittel                                          -- Speziallfall
        FROM
            abfahrten
        WHERE
            trip_headsign <> stop_name
        AND
            stop_name = 'Dulliken'
        AND
            route_desc IN ('RegioExpress')
        AND
            trip_headsign IN ('Olten')
        GROUP BY
            stop_name,
            linienname,
            agency_name,
            verkehrsmittel
    ) AS dulliken
    GROUP BY
        dulliken.stop_name,
        dulliken.linienname,
        dulliken.agency_name,
        dulliken.verkehrsmittel

    UNION ALL

    -- Bahnhof Grenchen Süd
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Grenchen Süd'
    AND
        linienname IN ('Linie 410 Biel - Olten (ICN)', 'Linie 410 Biel - Olten (RE)')                                                      -- prüfen ob nötig
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Däniken: (650 Olten-Zürich R,S und 450 Bern - Olten haben die gleichen route_ids!
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Däniken'
    AND
        linienname = 'Linie 650 Olten - Aarau (S23/S26/S29)'                                                     -- prüfen ob nötig
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

     -- Bahnhof Schönenwerd SO
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Schönenwerd SO'
    AND
        linienname = 'Linie 650 Olten - Aarau (S23/S26/S29)'                                                     -- prüfen ob nötig
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Murgenthal: (650 Olten-Zürich R,S und 450 Bern - Olten haben die gleichen route_ids!
    SELECT
        stop_name,
        linie.linienname,
        agency.agency_name,
        count(departure_time) as gtfs_count,
        CASE                                                                                                               -- Bedarfsangebot???
                WHEN route_desc= 'Bus'
                     THEN 1                                                                                                -- Bus (200 ICB? weggelassen)
                WHEN route_desc IN ('RegioExpress', 'InterRegio', 'Intercity')
                     THEN 2                                                                                                -- Intercity, Railjet, Schnellzug, Eurocity, ICE, TGV, Eurostar, InterRegio (105 Nachtzug weggelassen)
                WHEN route_desc IN ('Regionalzug', 'S-Bahn',  'Tram')
                    THEN 3 
            END AS verkehrsmittel
        FROM
             avt_oevkov_${currentYear}.gtfs_agency AS agency,
            avt_oevkov_${currentYear}.gtfs_route AS route,
            avt_oevkov_${currentYear}.gtfs_trip AS trip,
            avt_oevkov_${currentYear}.gtfs_stoptime AS stoptime,
            avt_oevkov_${currentYear}.gtfs_stop AS stop,
            avt_oevkov_${currentYear}.sachdaten_linie_route AS linie
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
        stop.stop_name = 'Murgenthal'
    AND
        linie.linienname = 'Linie 450 Langenthal - Olten (S23/S29)'
    AND
        pickup_type = 0
    AND
       route_desc IN (
           'Intercity', 'ICE', 'InterRegio', 'RegioExpress',
           'Regionalzug', 'S-Bahn', 'Bus', 'Tram'
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
    AND
        trip_headsign <> stop.stop_name
    GROUP BY
        stop.stop_name,
        linie.linienname,
        agency.agency_name,
        verkehrsmittel

     UNION ALL

    -- Bahnhof Dornach-Arlesheim: 230 Biel - Delémont und 500 Basel-Olten S haben die gleiche route_id = 4-3-j19-1 
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Dornach-Arlesheim'
    AND
        linienname = 'Linie 230 Biel - Delémont (RE/ICN)'                                                -- warum?????????????????????????
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Dornach, Bahnhof'                                                              -- warum?????????????????????????
    AND
        linienname <> 'L62 ????'
    AND
        linienname <> 'L63 ????'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count) / 2,                                                                                 -- Achtung count / 2
        verkehrsmittel                                                                                         -- trip_headsign <> stop.stop_name weggelassen, wegen Rundkurs
    FROM
        abfahrten
    WHERE                                                                                                      
        stop_name = 'Dornach, Bahnhof'
    AND
        linienname = 'Linie 66 Ortsbus Dornach'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Grenchen Nord
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Grenchen Nord'
    AND
        route_desc = 'RegioExpress'       -- InterCity werden nicht gezaehlt
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

--     'Bahnhof: Flüh, Bahnhof'
--     im GTFS keine Unterscheidung Flüh, Bahnhof (beides Tram und Bus), Abt. OeV wünscht aber unterscheidung
    SELECT
        'Flüh Bahnhof' AS stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> 'Flüh, Bahnhof'
    AND
        stop_name = 'Flüh, Bahnhof'
    AND
        route_desc = 'Tram'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

--  'Bahnhof: Flüh, Bahnhof'
    SELECT
        'Flüh, Bahnhof' AS stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        verkehrsmittel
    FROM
        abfahrten
    WHERE
        trip_headsign <> 'Flüh, Bahnhof'
    AND
        stop_name = 'Flüh, Bahnhof'
    AND
         route_desc = 'Bus'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

)
;

-- Alle  Haltestellen, die wegen pickup_type = 0 herausfallen oder 0 Abfahrten haben und nicht in Tabelle
-- avt_oevkov_${currentYear}.auswertung_auswertung_gtfs sind >>> ja, siehe Realisierungsphase: fragen_180925_erg_AVT.docx

INSERT INTO
     avt_oevkov_${currentYear}.auswertung_auswertung_gtfs
     (
          haltestellenname,
          linie, unternehmer,
          anzahl_abfahrten_linie,
          verkehrsmittel
     )
     (
        WITH calendar AS (
        SELECT
            service_id,
        CASE
        WHEN (SELECT BTRIM(lower(to_char((
                         SELECT
                                 stichtag
                             FROM
                                    avt_oevkov_${currentYear}.sachdaten_oevkov_daten), 'Day')))) = 'thursday'
             THEN thursday
        WHEN (SELECT BTRIM(lower(to_char((
                         SELECT
                                 stichtag
                             FROM
                                    avt_oevkov_${currentYear}.sachdaten_oevkov_daten), 'Day')))) = 'tuesday'
             THEN tuesday
        END AS dayofweek
        FROM
            avt_oevkov_${currentYear}.gtfs_calendar
    ),
    exception AS (
        SELECT
            service_id,
            exception_type
        FROM
            avt_oevkov_${currentYear}.gtfs_calendar_dates
        WHERE
            datum = (
                            SELECT
                                stichtag
                            FROM
                                avt_oevkov_${currentYear}.sachdaten_oevkov_daten)
    )
     SELECT
         stop_name,
         linie.linienname,
         agency.agency_name,
         0 as gtfs_count,
         CASE                                                                                                         -- Bedarfsangebot????
                WHEN route_desc = 'Bus'
                     THEN 1                                                                                             -- Bus (200 ICB? weggelassen)
                WHEN route_desc IN ('RegioExpress', 'InterRegio', 'Intercity')
                     THEN 2                                                                                             -- Railjet, Schnellzug, Eurocity, ICE, TGV, Eurostar, InterRegio (105 Nachtzug weggelassen)
                WHEN route_desc IN ('Regionalzug', 'S-Bahn', 'Tram')
                    THEN 3
            END AS verkehrsmittel
     FROM
        avt_oevkov_${currentYear}.gtfs_agency AS agency,
        avt_oevkov_${currentYear}.gtfs_route AS route,
        avt_oevkov_${currentYear}.gtfs_trip AS trip,
        avt_oevkov_${currentYear}.gtfs_stoptime AS stoptime,
        avt_oevkov_${currentYear}.gtfs_stop AS stop,
        avt_oevkov_${currentYear}.sachdaten_linie_route AS linie
     WHERE
         (
         trip.service_id IN (
             SELECT
                 service_id
             FROM
                 calendar
             WHERE
                 dayofweek = 1
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
    stop.stop_name||linienname NOT IN (
        SELECT
            haltestellenname||linie
        FROM 
            avt_oevkov_${currentYear}.auswertung_auswertung_gtfs
    )
    AND
         stop.stop_name NOT IN ('Aarau', 'Langenthal', 'Murgenthal', 'Zofingen')
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
    AND
        pickup_type > 0
    AND
        route_desc = 'Bus'
     GROUP BY
    stop.stop_name,
    linie.linienname,
    agency.agency_name,
    verkehrsmittel
)
;

-- Gewichtung schreiben
UPDATE
    avt_oevkov_${currentYear}.auswertung_auswertung_gtfs AS auswertung
SET
    gewichtung = verkehrsmittel.gewichtung
FROM
    avt_oevkov_${currentYear}.sachdaten_verkehrsmittel AS verkehrsmittel
WHERE
    auswertung.verkehrsmittel = verkehrsmittel.verkehrsmittel
;
COMMIT;
;