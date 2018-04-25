SELECT
    id,
    name,
    ogc_fid AS t_id,
    schutzstatus,
    gemeinde,
    strasse,
    hausnummer,
    uuid
FROM 
    ada_adagis_d."object"
WHERE 
    archive = 0