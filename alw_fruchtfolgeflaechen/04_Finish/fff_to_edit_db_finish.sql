SELECT 
    geometrie, 
    bezeichnung, 
    spezialfall, 
    datenstand, 
    anrechenbar, 
    st_area(geometrie)/100 AS area_aren,
    (st_area(geometrie)/100)*anrechenbar AS area_anrech
FROM 
    alw_fruchtfolgeflaechen.fruchtfolgeflaeche_clean
;
