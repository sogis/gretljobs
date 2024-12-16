-- Leere vorgängig alle Tabellen
DELETE FROM awa_stromversorgungssicherheit_mgdm_v1.ruledarea_level3;
DELETE FROM awa_stromversorgungssicherheit_mgdm_v1.ruledarea_level5;
DELETE FROM awa_stromversorgungssicherheit_mgdm_v1.ruledarea_level7;
DELETE FROM awa_stromversorgungssicherheit_mgdm_v1.organisation;

WITH orgs AS (
    -- Füge im ersten Schritt die Organisationen in die Datenbank, die t_id 
    -- werden im nächsten Schritt weiterverwendet
    INSERT INTO
        awa_stromversorgungssicherheit_mgdm_v1.organisation (aname, website)
    SELECT
        o.organisation_name AS aname,
        o.web AS website
    FROM
        agi_lk_netzgebiete_v1.organisation o
    LEFT JOIN
        agi_lk_netzgebiete_v1.netzgebiet n
    ON
        n.betreiber = o.t_id
    WHERE
        n.amedium IN ( 'Elektrizitaet.Netzebene_3',
                       'Elektrizitaet.Netzebene_5',
                       'Elektrizitaet.Netzebene_7' )
    GROUP BY
        o.organisation_name, o.web
    RETURNING *
),
netzgebiete AS (
    SELECT
        n.amedium,
        p.geometrie AS ageometry,
        p.bezeichnung AS aname,
        'SO' AS canton,
        TRUE AS legalforce,
        org2.t_id AS operator
    FROM
        agi_lk_netzgebiete_v1.netzgebiet n 
    LEFT JOIN
        agi_lk_netzgebiete_v1.perimeter p 
    ON
        n.perimeter = p.t_id
    LEFT JOIN
        agi_lk_netzgebiete_v1.organisation o
    ON
        n.betreiber = o.t_id
    LEFT JOIN
        orgs org2
    ON
        o.organisation_name = org2.aname
),
level3_inserts AS (
    INSERT INTO
        awa_stromversorgungssicherheit_mgdm_v1.ruledarea_level3 (ageometry, aname, canton, legalforce, operator)
    SELECT
        ageometry,
        aname,
        canton,
        legalforce,
        operator
    FROM
        netzgebiete
    WHERE 
        amedium LIKE 'Elektrizitaet.Netzebene_3'
),
level5_inserts AS (
    INSERT INTO
        awa_stromversorgungssicherheit_mgdm_v1.ruledarea_level5 (ageometry, aname, canton, legalforce, operator)
    SELECT
        ageometry,
        aname,
        canton,
        legalforce,
        operator
    FROM
        netzgebiete
    WHERE 
        amedium LIKE 'Elektrizitaet.Netzebene_5'
)
INSERT INTO
    awa_stromversorgungssicherheit_mgdm_v1.ruledarea_level7 (ageometry, aname, canton, legalforce, operator)
SELECT
    ageometry,
    aname,
    canton,
    legalforce,
    operator
FROM
    netzgebiete
WHERE 
    amedium LIKE 'Elektrizitaet.Netzebene_7'
;