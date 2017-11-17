SELECT 
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    objectid,
    massnr,
    shape_length,
    prioritaet,
    frist,
    bemerkung,
    darstellung
FROM 
    gewisso.abschnprio_gdbsigmas
WHERE 
    archive = 0
;
