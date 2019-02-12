SELECT
    DISTINCT ON
--     (route_id, stop_name, trip_headsign, route_desc)
    (route_id, trip_headsign, route_desc)
    trip.route_id,
    stop_name, 
    trip_headsign,
    route_desc
FROM
    avt_oevkov_2019.gtfs_route AS route,
    avt_oevkov_2019.gtfs_trip AS trip,
    avt_oevkov_2019.gtfs_stoptime AS stoptime,
    avt_oevkov_2019.gtfs_stop AS stop
WHERE
   (
        trip.service_id IN (
            SELECT
                service_id
            FROM
                avt_oevkov_2019.gtfs_calendar
            WHERE thursday = 1
        )
        OR
        trip.service_id IN (
        SELECT
            service_id
        FROM
            avt_oevkov_2019.gtfs_calendar_dates
        WHERE
            datum = (SELECT
                                stichtag
                            FROM
                                avt_oevkov_2019.sachdaten_oevkov_daten)
        AND
             exception_type = 1
         )
    )
AND
    trip.service_id NOT IN (
        SELECT
            service_id
        FROM
            avt_oevkov_2019.gtfs_calendar_dates
        WHERE
            datum = (SELECT
                                stichtag
                            FROM
                                avt_oevkov_2019.sachdaten_oevkov_daten)
        AND
            exception_type = 2
    )
-- AND
--     stoptime.stop_sequence = 1
AND
    stop.stop_name NOT IN ('Aarau', 'Langenthal', 'Murgenthal', 'Zofingen')          -- die werden nur für die Berechnung benötigt
-- AND
--     route.route_id LIKE '%508%'
AND
    route.route_id = trip.route_id
AND
    stoptime.trip_id = trip.trip_id
AND
    stop.stop_id = stoptime.stop_id
ORDER BY
    trip.route_id,
--     stop_name, 
    trip_headsign,
    route_desc
;