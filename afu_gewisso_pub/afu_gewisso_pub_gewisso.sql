SELECT 
    gewisso.ogc_fid AS t_id, 
    ST_Force_2D(gewisso.wkb_geometry) AS geometrie, 
    gewisso.dh_gew, 
    gewisso.hauptgnr, 
    gewisso.nebengnr, 
    gewisso.gewissnr, 
    gewisso.abschnitt, 
    gewisso.gnrso, 
    gewisso.meas_unten, 
    gewisso.meas_oben, 
    gewisso.name, 
    gewisso.typ, 
    CASE
        WHEN gewisso.typ = 0
            THEN 'offen'
        WHEN gewisso.typ = 1
            THEN 'eingedolt'
        WHEN gewisso.typ = 2
            THEN 'parallel'
        WHEN gewisso.typ = 3
            THEN 'Seeufer'
        WHEN gewisso.typ = 4
            THEN 'virtuell'
        WHEN gewisso.typ = 5
            THEN 'Karst'
        WHEN gewisso.typ = 6
            THEN 'versickert'
        WHEN gewisso.typ = 7
            THEN 'Stausee'
        WHEN gewisso.typ = 8
            THEN 'Insel'
        WHEN gewisso.typ = 9
            THEN 'unterirdisch'
        WHEN gewisso.typ = 10
            THEN 'Kanal'
        WHEN gewisso.typ = 11
            THEN 'Entlastung'
        WHEN gewisso.typ = 12
            THEN 'Graben'
        WHEN gewisso.typ = 13
            THEN 'Drainage'
        WHEN gewisso.typ = 14
            THEN 'andere'
        WHEN gewisso.typ = 15
            THEN 'Kanal eingedolt'
        WHEN gewisso.typ = 16
            THEN 'Entlastung eingedolt'
        WHEN gewisso.typ = 17
            THEN 'Graben eingedolt'
        WHEN gewisso.typ = 18
            THEN 'Drainage eingedolt'
        WHEN gewisso.typ = 19
            THEN 'andere eingedolt'
        WHEN gewisso.typ = 20
            THEN 'parallel eingedolt'
    END AS typ_text,
    CASE
        WHEN 
            gewisso.typ IN (0, 2, 3, 5, 7, 8, 10, 11)
            AND 
            gewisso.privat = 0
                THEN 'öffentliches Gewässer offen'
        WHEN 
            gewisso.typ IN (1, 6, 9, 15, 16, 20)
            AND 
            gewisso.privat = 0
                THEN 'öffentliches Gewässer eingedolt'
        WHEN 
            gewisso.typ IN (0, 2, 3, 5, 7, 8, 10, 11)
            AND 
            gewisso.privat = 1
                THEN 'privates Gewässer offen'
        WHEN 
            gewisso.typ IN (1, 6, 9, 15, 16, 20)
            AND 
            gewisso.privat = 1
                THEN 'privates Gewässer eingedolt'
    END AS status,
    gewisso.groesse, 
    gewisso.gemeinde, 
    gewisso.gem2, 
    gewisso.qualitaet, 
    gewisso.privat, 
    gewisso.vorf_gewis, 
    gewisso.vorf_neben, 
    gewisso.dh_km, 
    gewisso.strahler, 
    gewisso.groesse * 3 + 10 AS schriftgroesse
FROM 
    gewisso.gewisso
WHERE 
    archive = 0
;
