SELECT 
    t_ili_tid, 
    prozessa, 
    geometrie, 
    gef_stufe, 
    aindex, 
    bemerkung, 
    gk_art, 
    publiziert, 
    ngkid
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_kont_sackung
WHERE 
    aindex is not null 
;