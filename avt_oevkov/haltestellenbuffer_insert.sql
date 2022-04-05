DELETE FROM avt_oevkov_${currentYear}_v1.so_geodaten_haltestellenbuffer
;
INSERT INTO avt_oevkov_${currentYear}_v1.so_geodaten_haltestellenbuffer
    (
    haltestellenname,
    verkehrsmittel,
    geometrie
    )
    (
    SELECT
        DISTINCT ON (haltestelle.haltestellenname) haltestelle.haltestellenname,
        CASE
            WHEN verkehrsmittel IN (1,4)
                THEN 'Bus'
            WHEN verkehrsmittel IN (2, 3)
                THEN 'Bahn'
        ELSE ''
        END AS verkehrsmittel,
        CASE
            WHEN verkehrsmittel IN (1,4)
                THEN ST_Buffer(haltestelle.geometrie, 250, 'quad_segs=16')
            WHEN verkehrsmittel IN (2, 3) 
                THEN ST_Buffer(haltestelle.geometrie, 500, 'quad_segs=16')
           ELSE ST_Buffer(haltestelle.geometrie, 50, 'quad_segs=16')
        END AS geometrie
    FROM
        avt_oevkov_${currentYear}_v1.so_geodaten_haltestellen AS haltestelle
        LEFT JOIN avt_oevkov_${currentYear}_v1.auswertung_gesamtauswertung AS auswertung
            ON haltestelle.haltestellenname = auswertung.haltestellenname 
    WHERE auswertung.anrechnung > 0
    )
;
