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
    afu_gefahrenkartierung.gefahrenkartirung_gk_absenkung_einsturz
where 
    aindex is not null 
;
