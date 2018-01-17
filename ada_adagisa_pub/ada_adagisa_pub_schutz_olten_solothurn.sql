SELECT
    ogc_fid AS t_id,
    id,
    ort,
    wkb_geometry AS geometrie
FROM 
    ada_adagis_a.schutz_olten_solothurn
WHERE
    archive = 0
;