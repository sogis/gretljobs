INSERT INTO avt_oevkov_${currentYear}_v1.so_geodaten_haltestellenbuffer
    (
        haltestellenname,
        verkehrsmittel,
        geometrie
    )
    (
        SELECT
            DISTINCT ON (haltestelle.haltestellenname) haltestelle.haltestellenname,
            verkehrsmittel,
            CASE
                WHEN verkehrsmittel = 'Bahn'
                    THEN ST_Buffer(haltestelle.geometrie, 500, 'quad_segs=16')
                WHEN verkehrsmittel = 'Tram'
                    THEN ST_Buffer(haltestelle.geometrie, 350, 'quad_segs=16')
                WHEN verkehrsmittel = 'Bus'
                    THEN ST_Buffer(haltestelle.geometrie, 250, 'quad_segs=16')
            END AS geometrie
        FROM
            avt_oevkov_${currentYear}_v1.so_geodaten_haltestellen AS haltestelle
            LEFT JOIN avt_oevkov_${currentYear}_v1.auswertung_gesamtauswertung AS auswertung
                ON haltestelle.haltestellenname = auswertung.haltestellenname 
        WHERE
            auswertung.anrechnung > 0
    )
;
