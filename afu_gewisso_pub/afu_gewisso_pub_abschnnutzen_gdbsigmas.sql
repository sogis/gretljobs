SELECT 
    ogc_fid AS t_id,
    ST_Force_2D(wkb_geometry) as geometrie,
    objectid,
    shape_length,
    nutzen,
    bemerkung
FROM 
    gewisso.abschnnutzen_gdbsigmas
WHERE 
    archive = 0
;