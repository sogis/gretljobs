SELECT 
    t_ili_tid, 
    geometrie, 
    gef_stufe, 
    aindex
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_gk_synoptisch_generiert
WHERE 
    aindex is not null 
;
