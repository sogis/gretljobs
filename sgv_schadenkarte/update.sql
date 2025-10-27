--UPDATE, wo egrid und egid korrekt sind! 
WITH 
    gebaeude AS (
        SELECT 
            geb.geometrie, 
            geb.egid,
            grund.egrid  
        FROM 
            agi_gebaeudeinformationen_pub_v1.gebaeude_gebaeude geb
        LEFT JOIN 
            agi_mopublic_pub.mopublic_grundstueck grund
            ON 
            ST_DWITHIN(geb.geometrie, grund.geometrie,0)
    )
UPDATE 
    sgv_schadenkarte_pub_v1.schadenfall AS s
    SET geometrie = st_pointonsurface(g.geometrie) 
FROM 
    gebaeude g
WHERE 
    s.egid = g.egid
    AND 
    s.egrid = g.egrid 
    AND
    (s.geometrie IS NULL OR ST_IsEmpty(s.geometrie))
;

--UPDATE wo Daten nur im GWR gefunden werden können.
WITH 
    gebaeude AS (
        SELECT 
            lage AS geometrie, 
            egid,
            egrid
        FROM 
            agi_gwr_pub_v1.gwr_gebaeude 
    )
UPDATE 
    sgv_schadenkarte_pub_v1.schadenfall AS s
    SET geometrie = g.geometrie, 
        problem = 'INFO: EGRID / EGID nur im GWR gefunden.'
FROM 
    gebaeude g
WHERE 
    s.egid = g.egid
    AND 
    s.egrid = g.egrid 
    AND
    (s.geometrie IS NULL OR ST_IsEmpty(s.geometrie))
;

--UPDATE über EGID und Adresse 
WITH  
    adressen AS (
        SELECT 
            CONCAT(
                eingang->>'Strassenname', ' ',
                eingang->>'Hausnummer', ', ',
                eingang->>'PLZ', ' ',
                eingang->>'Ortschaft'
            ) AS adresse, 
            g.egid AS egid, 
            g.geometrie
        FROM 
            agi_gebaeudeinformationen_pub_v1.gebaeude_gebaeude g,
            LATERAL jsonb_array_elements(g.gebaeudeeingang) AS eingang
    )
UPDATE 
    sgv_schadenkarte_pub_v1.schadenfall AS s
    SET geometrie = st_pointonsurface(g.geometrie), 
        problem = 'PROBLEM: EGRID Falsch (EGID und Adresse stimmen überein)'
FROM 
    adressen g
WHERE 
    s.egid = g.egid
    AND 
    s.beschreibung  = g.adresse 
    AND
    (s.geometrie IS NULL OR ST_IsEmpty(s.geometrie))
;

--UPDATE über EGRID und Adresse 
WITH  
    adressen AS (
        SELECT 
            CONCAT(
                eingang->>'Strassenname', ' ',
                eingang->>'Hausnummer', ', ',
                eingang->>'PLZ', ' ',
                eingang->>'Ortschaft'
            ) AS adresse, 
            grund.egrid AS egrid, 
            g.geometrie
        FROM 
            agi_gebaeudeinformationen_pub_v1.gebaeude_gebaeude AS g
        CROSS JOIN LATERAL 
            jsonb_array_elements(g.gebaeudeeingang) AS eingang
        LEFT JOIN 
            agi_mopublic_pub.mopublic_grundstueck AS grund
            ON 
            ST_DWithin(g.geometrie, grund.geometrie, 0)
    )
UPDATE 
    sgv_schadenkarte_pub_v1.schadenfall AS s
    SET geometrie = st_pointonsurface(g.geometrie), 
        problem = 'PROBLEM: EGID Falsch (EGRID und Adresse stimmen überein)'
FROM 
    adressen g
WHERE 
    s.egrid = g.egrid
    AND 
    s.beschreibung  = g.adresse 
    AND
    (s.geometrie IS NULL OR ST_IsEmpty(s.geometrie))
;

--Alle anderen Fälle, welche nicht verknüpft werden können. 

UPDATE 
    sgv_schadenkarte_pub_v1.schadenfall
    SET problem = 'EGRID, EGID und/oder Adresse stimmen nicht überein. Bitte manuell überprüfen.'
WHERE
    geometrie IS NULL 
;

--Grundbuchkreise werden ergänzt
UPDATE  
    sgv_schadenkarte_pub_v1.schadenfall s 
    SET grundbuchkreis = g.aname  
FROM
    agi_av_gb_admin_einteilung_pub.grundbuchkreise_grundbuchkreis g 
WHERE 
    st_dwithin(s.geometrie, g.perimeter,0)
    AND 
    s.geometrie IS NOT NULL 
    
