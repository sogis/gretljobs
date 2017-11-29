SELECT 
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    id,
    ohb_code
FROM 
    awjf.oberhoehenbonitaet
WHERE 
    archive = 0
;
