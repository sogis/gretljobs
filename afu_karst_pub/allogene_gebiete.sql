SELECT 
    untere_hoehe, 
    obere_hoehe, 
    area, 
    geometrie, 
    innerhalb_so,
    CASE
        WHEN innerhalb_so IS TRUE 
        THEN 'Ja'
        ELSE 'Nein'
    END AS innerhalb_so_txt    
FROM 
    afu_karst_v1.karst_allogene_gebiete
;
