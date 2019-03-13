TRUNCATE avt_oevkov_${currentYear}.so_geodaten_haltestellenbuffer
;
INSERT INTO avt_oevkov_${currentYear}.so_geodaten_haltestellenbuffer
    (
    haltestellenname,
    verkehrsmittel,
    geometrie
    )
    (
    SELECT
        DISTINCT stop.haltestellenname,
        CASE
            WHEN verkehrsmittel IN (1,4)
                THEN 'Bus'
            WHEN verkehrsmittel IN (2, 3)
                THEN 'Bahn'
        ELSE ''
        END AS verkehrsmittel,
        CASE
            WHEN verkehrsmittel IN (1,4)
                THEN ST_Buffer(stop.geometrie, 250, 'quad_segs=16')
            WHEN verkehrsmittel IN (2, 3) 
                THEN ST_Buffer(stop.geometrie, 500, 'quad_segs=16')
           ELSE ST_Buffer(stop.geometrie, 50, 'quad_segs=16')
        END AS geometrie
    FROM
        avt_oevkov_${currentYear}.so_geodaten_haltestellen AS stop
        LEFT JOIN avt_oevkov_${currentYear}.auswertung_auswertung_gtfs AS auswertung
            ON stop.haltestellenname = auswertung.haltestellenname
    )
;