SELECT
    point_geometrie.ogc_fid AS t_id,
    object_id,
    wkb_geometry AS geometrie,
    "object"."name",
    "object".uuid,
    schutzstatus,
    gemeinde,
    strasse,
    hausnummer
FROM
    ada_adagis_d.point_geometrie
    LEFT JOIN ada_adagis_d."object"
    ON "object".uuid = point_geometrie.uuid
WHERE
    "object".archive = 0
    AND
    point_geometrie.archive = 0
;