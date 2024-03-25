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
    afu_gefahrenkartierung.gefahrenkartirung_gk_wasser
where 
    aindex is not null 
;
