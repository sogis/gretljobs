SELECT
    (st_dump(geometrie)).geom AS geometrie, 
    CASE 
        WHEN fffart IN (1,4) 
        THEN 'geeignet'
        WHEN fffart IN (2,6) 
        THEN 'bedingt_geeignet'
        WHEN fffart = 3
        THEN 'bedingt_geeignet'
    END AS bezeichnung, 
    CASE
        WHEN fffart = 4 
        THEN 'Kiesgrube_Abbaugebiet'
        WHEN fffart = 6 
        THEN 'Golfplatz'
        WHEN fffart = 3
        THEN 'Reservezone'
        ELSE null 
    END AS spezialfall, 
    datum_erst::date AS datenstand, 
    anrechenbar AS anrechenbar, 
    st_area(geometrie)/100 AS area_aren, 
    (st_area(geometrie)/100)*anrechenbar AS area_anrech
from 
    alw_grundlagen_pub.fruchtfolgeflaechen
