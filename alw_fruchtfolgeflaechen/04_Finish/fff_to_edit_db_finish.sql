select 
    geometrie AS geometrie, 
    bezeichnung, 
    spezialfall, 
    bfs_nr as bfs_nr,
    to_char(datenstand, 'DD.MM.YYYY') as datenstand, 
    anrechenbar, 
    st_area(geometrie)/100 as area_aren,
    (st_area(geometrie)/100)*anrechenbar as area_anrech
from 
    alw_fruchtfolgeflaechen.fff_komplett_gemeinden 
;