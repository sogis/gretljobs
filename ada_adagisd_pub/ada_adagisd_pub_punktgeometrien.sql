SELECT
    point_geometrie.ogc_fid AS t_id,
    object_id,
    wkb_geometry AS geometrie,
    "object"."name",
    "object".uuid,
    schutzstatus,
    gemeinde,
    strasse,
    hausnummer, 
    CASE 
        WHEN schutzstatus = 1 
            THEN 'Geschützt'
        WHEN schutzstatus = 2 
            THEN 'Erhaltenswert'
        WHEN schutzstatus = 3 
            THEN 'Schützenswert'
        WHEN schutzstatus = 4 
            THEN 'Ohne Einstufung'
    END AS schutzstatus_text
FROM
    ada_adagis_d.point_geometrie
    LEFT JOIN ada_adagis_d."object"
    ON "object".uuid = point_geometrie.uuid
WHERE
    "object".archive = 0
    AND
    point_geometrie.archive = 0
;
