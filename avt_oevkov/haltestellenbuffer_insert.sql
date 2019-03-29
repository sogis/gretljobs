TRUNCATE avt_oevkov_${currentYear}.so_geodaten_haltestellenbuffer
;
INSERT INTO avt_oevkov_${currentYear}.so_geodaten_haltestellenbuffer
    (haltestellenname, verkehrsmittel, geometrie)
    (SELECT
        DISTINCT stop_name,
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
        avt_oevkov_${currentYear}.gtfs_stop AS stop
        LEFT JOIN avt_oevkov_${currentYear}.auswertung_auswertung_gtfs AS auswertung
            ON stop.stop_name = auswertung.haltestellenname
    )

-- DROP INDEX IF EXISTS so_geodaten_haltestellenbuffer_idx
-- ;
-- CREATE INDEX so_geodaten_haltestellenbuffer_idx
--     ON avt_oevkov_${currentYear}.so_geodaten_haltestellenbuffer
--     USING gist
--     (geometrie)
-- ;