SELECT
    (st_dump(geometrie)).geom AS geometrie, 
    bezeichnung, 
    spezialfall, 
    to_char(datenstand, 'DD.MM.YYYY') AS datenstand, 
    anrechenbar, 
    st_area(geometrie)/100 AS area_aren,
    (st_area(geometrie)/100)*anrechenbar AS area_anrech
FROM 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung 
;
