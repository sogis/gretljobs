SELECT 
    t_ili_tid, 
    geometrie, 
    gef_stufe, 
    aindex, 
    bemerkung, 
    gk_art, 
    publiziert, 
    ngkid
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_spontan
WHERE 
    aindex is not null 
;