SELECT 
    ogc_fid AS t_id,
    ST_Force_2D(wkb_geometry) AS geometrie,
    gnrso,
    location,
    abschnr,
    bauwnr,
    bauwtyp,
    bauwhoeh,
    erhebungsdatum
FROM 
    gewisso.oeko_bauwerke
WHERE 
    archive = 0
;
