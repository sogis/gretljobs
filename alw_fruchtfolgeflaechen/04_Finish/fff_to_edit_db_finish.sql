select 
    geometrie, 
    bezeichnung, 
    spezialfall, 
    bfs_nr,
    datenstand, 
    anrechenbar, 
    st_area(geometrie)/100 as area_aren,
    (st_area(geometrie)/100)*anrechenbar as area_anrech
from 
    alw_fruchtfolgeflaechen.fruchtfolgeflaeche_clean
;