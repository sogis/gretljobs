SELECT
    DISTINCT haltestellenname
FROM
    avt_oevkov_2019.so_geodaten_haltestellen
WHERE
    haltestellenname NOT IN (
        SELECT
            stop_name
        FROM
            avt_oevkov_2019.gtfs_stop
    )
ORDER BY
    haltestellenname
;

SELECT
    DISTINCT stop_name
FROM
    avt_oevkov_2019.gtfs_stop
WHERE
    stop_name NOT IN (
        SELECT
            haltestellenname
        FROM
            avt_oevkov_2019.so_geodaten_haltestellen
    )
AND
    stop_name NOT IN (
    'Aarau', 'Langenthal', 'Zofingen'
    )
ORDER BY
    stop_name
;