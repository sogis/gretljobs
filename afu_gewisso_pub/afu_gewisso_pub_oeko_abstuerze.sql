SELECT 
    ogc_fid AS t_id,
    ST_Force_2D(wkb_geometry) AS geometrie,
    gnrso,
    location,
    abschnr,
    abstnr,
    absttyp,
    abstmat,
    absthoeh,
    erhebungsdatum
FROM 
    gewisso.oeko_abstuerze
WHERE 
    archive = 0
;