DELETE FROM 
    ${DB_SCHEMA}.gebaeude_gebaeude
;

-- Könnte man auch mit einer Query machen.
-- Vieles ist nun doppelt.

WITH gebaeudename AS (
    SELECT 
        objektname.objektname,
        bodenbedeckung.t_id
    FROM agi_mopublic_pub.mopublic_objektname_pos AS objektname
        JOIN agi_mopublic_pub.mopublic_bodenbedeckung AS bodenbedeckung
        ON ST_Contains(bodenbedeckung.geometrie , objektname.pos)
    WHERE objektname.art_txt = 'Gebaeude' AND objektname.herkunft = 'BB'
)
INSERT INTO 
    ${DB_SCHEMA}.gebaeude_gebaeude
    (
        bfs_nr,
        geometrie,
        egid,
        gebaeudename,
        gebaeudeeingang,
        link_gwr,
        astatus
    )
(
    SELECT
        bodenbedeckung.bfs_nr,
        bodenbedeckung.geometrie,
        bodenbedeckung.egid,
        string_agg(DISTINCT gebaeudename.objektname, ', ') AS gebaeudename,
        COALESCE(json_agg(DISTINCT jsonb_build_object(
            '@type', 'SO_AGI_Gebaeudeflaechen_Publikation_20240705.Gebaeude.Gebaeudeeingang',
            'Strassenname', adresse.strassenname, 
            'Hausnummer', adresse.hausnummer,
            'PLZ', adresse.plz,
            'Ortschaft', adresse.ortschaft,
            'EDID', adresse.edid,
            'ist_offizielle_Bezeichung', adresse.ist_offizielle_bezeichnung,
            'Hoehenlage', adresse.hoehenlage,
            'Status', adresse.astatus
        )) FILTER (WHERE adresse.hausnummer IS NOT NULL), NULL) AS gebaeudeeingang,
        CASE
            WHEN bodenbedeckung.egid IS NOT NULL
                THEN concat('https://www.housing-stat.ch/de/query/egid.html?egid=',bodenbedeckung.egid::TEXT)
            ELSE 'https://www.housing-stat.ch/'
        END AS link_gwr,
        'real' AS astatus
    FROM 
        agi_mopublic_pub.mopublic_bodenbedeckung AS bodenbedeckung
        LEFT JOIN agi_mopublic_pub.mopublic_gebaeudeadresse AS adresse 
        ON ST_Contains(bodenbedeckung.geometrie, adresse.lage)
        LEFT JOIN gebaeudename
        ON gebaeudename.t_id = bodenbedeckung.t_id
    WHERE 
        bodenbedeckung.art_txt = 'Gebaeude'
    GROUP BY 
        bodenbedeckung.egid, bodenbedeckung.bfs_nr, bodenbedeckung.geometrie
)
;

WITH gebaeudename AS (
    SELECT 
        objektname.objektname,
        bodenbedeckung.t_id
    FROM agi_mopublic_pub.mopublic_objektname_pos AS objektname
        JOIN agi_mopublic_pub.mopublic_bodenbedeckung_proj AS bodenbedeckung
        ON ST_Contains(bodenbedeckung.geometrie , objektname.pos)
    WHERE objektname.art_txt = 'Gebaeude' AND objektname.herkunft = 'BB'
)
INSERT INTO 
    ${DB_SCHEMA}.gebaeude_gebaeude
    (
        bfs_nr,
        geometrie,
        egid,
        gebaeudename,
        gebaeudeeingang,
        link_gwr,
        astatus
    )
(
    SELECT
        bodenbedeckung.bfs_nr,
        bodenbedeckung.geometrie,
        bodenbedeckung.egid,
        string_agg(gebaeudename.objektname, ', ') AS gebaeudename,
        COALESCE(json_agg(DISTINCT jsonb_build_object(
            '@type', 'SO_AGI_Gebaeudeflaechen_Publikation_20240705.Gebaeude.Gebaeudeeingang',
            'Strassenname', adresse.strassenname, 
            'Hausnummer', adresse.hausnummer,
            'PLZ', adresse.plz,
            'Ortschaft', adresse.ortschaft,
            'EDID', adresse.edid,
            'ist_offizielle_Bezeichung', adresse.ist_offizielle_bezeichnung,
            'Hoehenlage', adresse.hoehenlage,
            'Status', adresse.astatus
        )) FILTER (WHERE adresse.hausnummer IS NOT NULL), NULL) AS gebaeudeeingang,
        CASE
            WHEN bodenbedeckung.egid IS NOT NULL
                THEN concat('https://www.housing-stat.ch/de/query/egid.html?egid=',bodenbedeckung.egid::TEXT)
            ELSE 'https://www.housing-stat.ch/'
        END AS link_gwr,
        'projektiert' AS astatus
    FROM 
        agi_mopublic_pub.mopublic_bodenbedeckung_proj AS bodenbedeckung
        LEFT JOIN agi_mopublic_pub.mopublic_gebaeudeadresse AS adresse 
        ON ST_Contains(bodenbedeckung.geometrie, adresse.lage)
        LEFT JOIN gebaeudename
        ON gebaeudename.t_id = bodenbedeckung.t_id
    WHERE 
        bodenbedeckung.art_txt = 'Gebaeude'
    GROUP BY 
        bodenbedeckung.egid, bodenbedeckung.bfs_nr, bodenbedeckung.geometrie
)
;
