-- Summe ungewichtete Abfahrten pro Haltestelle und Linie
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
            CASE                                                                                                   -- Bedarfsangebot?
                WHEN route_desc = 'Bus'                                                               -- Bus (200 ICB? weggelassen)
                     THEN 1
                WHEN route_desc IN ('RegioExpress', 'InterRegio', 'Intercity')       -- Railjet, Schnellzug, Eurocity, ICE, TGV,
                     THEN 2                                                                                      -- Eurostar, InterRegio (105 Nachtzug weggelassen)
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
            stop.stop_name NOT IN (
                'Aarau',
                'Langenthal',
--                 'Murgenthal',
                'Zofingen'
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
               'Intercity',
               'ICE',
               'InterRegio',
               'RegioExpress',
               'Regionalzug',
               'S-Bahn',
               'Bus',
               'Tram'
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
       
    -- *********** hier kommen die Ausnahmen, die werden unten abgehandelt ***********
    
       -- Bahnhöfe werden separat behandelt wegen Zuordnung zu den LInien
       AND
           stop_name NOT IN (
              'Biberist RBS',
              'Dornach-Arlesheim',
              'Dornach, Bahnhof',
              'Flüh, Bahnhof',
--             'Grenchen Nord',
               'Grenchen Süd',
              'Lohn-Lüterkofen',
--               'Oensingen',
              'Olten',
              'Solothurn'
        )
    -- ***************************** Ende der Ausnahmen *********************************

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
        CASE                                                                                                                          -- Bedarfsangebot?
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
            'Arlesheim, Obesunne',
            'Erlinsbach, Oberdorf',
            'Erlinsbach, Sagi',
            'Gänsbrunnen',
            'Gänsbrunnen, Bahnhof',
            'Nuglar, Neunuglar', 
            'Niederbipp Industrie',
            'Walterswil-Striegel'
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
           'Intercity',
           'ICE',
           'InterRegio',
           'RegioExpress',
           'Regionalzug',
           'S-Bahn',
           'Bus',
           'Tram'
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
        linienname = 'L410 Biel - Olten (Regio)'
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
        linienname  IN (
            'L410 Biel - Olten (IC)',
            'L410 Biel - Olten - St. Gallen (IC)',
            'L410 Olten - Genève-Aéroport (IC)',
            'L410 Olten - Lausanne (IC)'
        )
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
        linienname = 'L411 Solothurn - Moutier'
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
    AND
        linienname = 'L413 Solothurn - Langenthal'
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
        3 AS verkehrsmittel                                                                                            -- Speziallfall, besser in Korrekturtabelle
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

    UNION ALL

     -- Biberist RBS Linie 308 Bern - Solothurn
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        3 AS verkehrsmittel                                                                                           -- SSpeziallfall, eigentlich besser in Korrekturtabelle
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

    UNION ALL

     -- Lohn-Lüterkofen Linie 308 Bern - Solothurn
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        3 AS verkehrsmittel                                                                                            -- Speziallfall, eigentlich besser in Korrekturtabelle
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
     
     UNION ALL

    -- Bahnhof Olten: Linie 230 Biel - Olten (Regio)
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
        linienname = 'L410 Biel - Olten (Regio)'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: Linie 230 Biel - Olten (IC)
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
        trip_headsign in ('Biel/Bienne', 'Genève-Aéroport', 'Lausanne')
    AND
        route_desc IN ('InterRegio', 'Intercity') 
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
     linienname = 'L500 Olten - Basel (S3)'
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
        linienname = 'L503 Olten - Sissach (S9)'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: L510 Olten - Sursee (S8)
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
        linienname = 'L510 Olten - Sursee (S8)'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL
        
    -- Bahnhof Olten: Linie 450 Langenthal - Olten (S23/S26/S29)
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
        trip_headsign IN ('Bern', 'Langenthal')
    AND
        route_desc IN ('Regionalzug', 'S-Bahn')
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: L450 Olten - Bern (IR) und L450 Olten - Bern (RE)
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
        trip_headsign IN ('Bern', 'Langenthal')
    AND
        trip_id IN (
            SELECT trip_einschraenkung.trip_id
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
        linienname = 'L503 Olten - Sissach (S9)'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL

    -- Bahnhof Olten: L510 Olten - Sursee (S8)
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
        linienname = 'L510 Olten - Sursee (S8)'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

    UNION ALL
        
    -- Bahnhof Olten: Linie 450 Langenthal - Olten (S23/S26/S29)
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
        trip_headsign IN ('Bern', 'Langenthal')
    AND
        route_desc IN ('Regionalzug', 'S-Bahn')
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel
         
    UNION ALL

 -- Bahnhof Olten: L450 Olten - Bern (IR) und L450 Olten - Bern (RE)
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
        linienname  IN (
           'L450 Olten - Bern (IR)',
           'L450 Olten - Bern (RE)'
      )
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

    -- Bahnhof Olten: Linie 510 Olten - Luzern (IR/RE)          RegioExpress zählt hier zu R
    SELECT
        stop_name,
        linienname,
        agency_name,
        sum(gtfs_count),
        2 AS verkehrsmittel                                                                                            -- Achtung: verkehrsmittel wird hier fix eingegeben!!!
    FROM
        abfahrten
    WHERE
        trip_headsign <> stop_name
    AND
        stop_name = 'Olten'
    AND
        trip_headsign IN (
            'Brig',
            'Chiasso',
            'Domodossoloa (I)',
            'Erstfeld',
            'Lugano',
            'Luzern'
        )
    AND
        linienname IN (                                                                                                 -- das muss zwingend stehen, weil route_id = 20-21-j19-1 für Olten-Basel und Olten-Luzern gilt
             'L510 Olten - Luzern (IR)',
             'L510 Olten - Luzern (RE)'
        )
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
                 trip_headsign IN (
                    'Brig',
                    'Chiasso',
                    'Domodossoloa (I)',
                    'Erstfeld',
                    'Lugano',
                    'Luzern'
                ) 
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

    -- Bahnhof Olten: L650 Olten - Lenzburg (S26) und L650 Turgi - Langenthal (S29)
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
         linienname IN (
             'L650 Olten - Lenzburg (S26)',
             'L650 Turgi - Langenthal (S29)'
        )
    AND
        trip_headsign IN ('Baden', 'Langenthal', 'Rotkreuz', 'Turgi')
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
        trip_headsign IN (
            'Romanshorn',
            'St. Gallen',
            'Wettingen',
            'Zürich Flughafen',
            'Zürich HB'
        )
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

--     UNION ALL

   --  -- Bahnhof Dulliken: (650 Olten-Zürich R, S und 450 Bern - Olten haben die gleichen route_ids!
--     -- S-Bahn zählen alle, RegioExpress nur die Abfahrten Richtung Olten!
--     SELECT
--         stop_name,
--         linienname,
--         agency_name,
--         sum(sum),
--         verkehrsmittel
--     FROM (
--         SELECT
--             stop_name,
--             'Linie 650 Olten - Aarau (S23/S26/S29???)' AS linienname,
--             agency_name,
--             sum(gtfs_count),
--             verkehrsmittel
--         FROM
--             abfahrten
--         WHERE
--             trip_headsign <> stop_name
--         AND
--             stop_name = 'Dulliken'
--         AND
--             route_desc IN ('Regionalzug', 'S-Bahn')
--         AND
-- --             linienname = 'Linie 650 Olten - Aarau (S23/S26/S29)'
--              linienname IN (
--                  'L450 Langenthal - Aarau (S23)',
--                  'L650 Olten - Lenzburg (S26)',
--                  'L650 Turgi - Langenthal (S29)'
--             )
--         GROUP BY
--             stop_name,
--             linienname,
--             agency_name,
--             verkehrsmittel
--         
--         UNION ALL
-- 
--         -- Bahnhof Dulliken: S-Bahn zählen alle, RegioExpress nur die Abfahrten Richtung Olten!
--         SELECT
--             stop_name,
--             'Linie 650 Olten - Zürich (RE/IR/ICN)????' AS linienname,
--             agency_name,
--             sum(gtfs_count),
--             2 AS verkehrsmittel                                          -- Speziallfall
--         FROM
--             abfahrten
--         WHERE
--             trip_headsign <> stop_name
--         AND
--             stop_name = 'Dulliken'
--         AND
--             route_desc IN ('RegioExpress')
--         AND
--             trip_headsign IN ('Olten')
--         GROUP BY
--             stop_name,
--             linienname,
--             agency_name,
--             verkehrsmittel
--     ) AS dulliken
--     GROUP BY
--         dulliken.stop_name,
--         dulliken.linienname,
--         dulliken.agency_name,
--         dulliken.verkehrsmittel
-- 
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
        linienname IN (
            'L410 Biel - Olten (IC)',
            'L410 Biel - Olten (Regio)',
            'L410 Biel - Olten - St. Gallen (IC)',
            'L410 Biel - Olten - Zürich HB (IC)',
            'L410 Olten - Genève-Aéroport (IC)',
            'L410 Olten - Lausanne (IC)'
        )
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

--     UNION ALL

   --  -- Bahnhof Däniken: (650 Olten-Zürich R,S und 450 Bern - Olten haben die gleichen route_ids!
--     SELECT
--         stop_name,
--         linienname,
--         agency_name,
--         sum(gtfs_count),
--         verkehrsmittel
--     FROM
--         abfahrten
--     WHERE
--         trip_headsign <> stop_name
--     AND
--         stop_name = 'Däniken'
--     AND
-- --         linienname = 'Linie 650 Olten - Aarau (S23/S26/S29)'
--      linienname IN (
-- 	 'L450 Langenthal - Aarau (S23)',
-- 	 'L650 Olten - Lenzburg (S26)',
-- 	 'L650 Turgi - Langenthal (S29)'
-- )
--     GROUP BY
--         stop_name,
--         linienname,
--         agency_name,
--         verkehrsmittel
-- 
--     UNION ALL

   --   -- Bahnhof Schönenwerd SO
--     SELECT
--         stop_name,
--         linienname,
--         agency_name,
--         sum(gtfs_count),
--         verkehrsmittel
--     FROM
--         abfahrten
--     WHERE
--         trip_headsign <> stop_name
--     AND
--         stop_name = 'Schönenwerd SO'
--     AND
-- --         linienname = 'Linie 650 Olten - Aarau (S23/S26/S29)'
--         linienname IN (
-- 	    'L450 Langenthal - Aarau (S23)',
-- 	    'L650 Olten - Lenzburg (S26)',
-- 	    'L650 Turgi - Langenthal (S29)'
--          )
--     GROUP BY
--         stop_name,
--         linienname,
--         agency_name,
--         verkehrsmittel
-- 
--     UNION ALL

 --    -- Bahnhof Murgenthal: (650 Olten-Zürich R,S und 450 Bern - Olten haben die gleichen route_ids!
--     SELECT
--         stop_name,
--         linie.linienname,
--         agency.agency_name,
--         count(departure_time) as gtfs_count,
--         CASE                                                                                                                 -- Bedarfsangebot?
--                 WHEN route_desc= 'Bus'
--                      THEN 1                                                                                                -- Bus (200 ICB? weggelassen)
--                 WHEN route_desc IN ('RegioExpress', 'InterRegio', 'Intercity')
--                      THEN 2                                                                                                -- Intercity, Railjet, Schnellzug, Eurocity, ICE, TGV, Eurostar, InterRegio (105 Nachtzug weggelassen)
--                 WHEN route_desc IN ('Regionalzug', 'S-Bahn',  'Tram')
--                     THEN 3 
--             END AS verkehrsmittel
--         FROM
--              avt_oevkov_${currentYear}.gtfs_agency AS agency,
--             avt_oevkov_${currentYear}.gtfs_route AS route,
--             avt_oevkov_${currentYear}.gtfs_trip AS trip,
--             avt_oevkov_${currentYear}.gtfs_stoptime AS stoptime,
--             avt_oevkov_${currentYear}.gtfs_stop AS stop,
--             avt_oevkov_${currentYear}.sachdaten_linie_route AS linie
--         WHERE
--             (
--             trip.service_id IN (
--                 SELECT
--                     service_id
--                 FROM
--                     calendar
--                 WHERE dayofweek = 1
--             )
--             OR
--             trip.service_id IN (
--                 SELECT
--                     service_id
--                 FROM
--                     exception
--                 WHERE
--                     exception_type = 1
--              )
--         )
--     AND
--         trip.service_id NOT IN (
--             SELECT
--                 service_id
--             FROM
--                 exception
--             WHERE
--                 exception_type = 2
--     )
--     AND
--         stop.stop_name = 'Murgenthal'
--     AND
-- --         linie.linienname = 'Linie 450 Langenthal - Olten (S23/S29)'
--           linie.linienname  IN (
--               'L450 Langenthal - Aarau (S23)',
--               'L450 Olten - Bern (IR)',
--               'L450 Olten - Bern (RE)'
--           )
--     AND
--         pickup_type = 0
--     AND
--        route_desc IN (
--            'Intercity',
--            'ICE',
--            'InterRegio'
--             'RegioExpress',
--            'Regionalzug',
--            'S-Bahn',
--            'Bus',
--            'Tram'
--        )
--     AND
--         agency.agency_id::text = route.agency_id
--     AND
--         route.route_id = trip.route_id
--     AND
--         route.route_id = linie.route_id
--     AND
--         stop.stop_id = stoptime.stop_id
--     AND
--         stoptime.trip_id = trip.trip_id
--     AND
--         trip_headsign <> stop.stop_name
--     GROUP BY
--         stop.stop_name,
--         linie.linienname,
--         agency.agency_name,
--         verkehrsmittel
-- 
     UNION ALL

  --   -- Bahnhof Dornach-Arlesheim: 230 Biel - Delémont und 500 Basel-Olten S haben die gleiche route_id = 4-3-j19-1 
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
        linienname = 'L230 Basel - Delémont (S3)'
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
        stop_name = 'Dornach, Bahnhof'
    AND
        linienname <> 'L62 Benken - Dornach'
    AND
        linienname <> 'L63 Dornach - Muttenz'
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
        linienname = 'L66 Ortsbus Dornach'
    GROUP BY
        stop_name,
        linienname,
        agency_name,
        verkehrsmittel

--     UNION ALL
-- 
--     -- Bahnhof Grenchen Nord
--     SELECT
--         stop_name,
--         linienname,
--         agency_name,
--         sum(gtfs_count),
--         verkehrsmittel
--     FROM
--         abfahrten
--     WHERE
--         trip_headsign <> stop_name
--     AND
--         stop_name = 'Grenchen Nord'
--     AND
--         route_desc = 'RegioExpress'                                                                          -- InterCity werden nicht gezaehlt
--     GROUP BY
--         stop_name,
--         linienname,
--         agency_name,
--         verkehrsmittel

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


-- Alle  Haltestellen, die wegen pickup_type = 0 herausfallen oder am Stichtag 0 Abfahrten haben
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
         CASE
                WHEN route_desc = 'Bus'
                     THEN 1
                WHEN route_desc IN ('RegioExpress', 'InterRegio', 'Intercity')
                     THEN 2
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