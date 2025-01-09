SELECT  
    verkarstungsgrad,
    verkarstungsgrad_liste.dispname AS verkarstungsgrad_txt,
    geologische_einheit_ga25, 
    lithostratigraphische_formation, 
    tektonische_einheit, 
    etm, 
    maechtigkeit, 
    maechtigkeit_liste.dispname AS maechtigkeit_txt,
    geometrie, 
    innerhalb_so, 
    CASE
        WHEN innerhalb_so IS TRUE 
        THEN 'Ja'
        ELSE 'Nein'
    END AS innerhalb_so_txt      
FROM 
    afu_karst_v1.karst_verkarstung verkarstung
LEFT JOIN 
    afu_karst_v1.karst_verkarstung_verkarstungsgrad verkarstungsgrad_liste 
    ON 
    verkarstungsgrad_liste.ilicode = verkarstung.verkarstungsgrad 
LEFT JOIN 
    afu_karst_v1.karst_maechtigkeit maechtigkeit_liste 
    ON 
    maechtigkeit_liste.ilicode = verkarstung.maechtigkeit 
