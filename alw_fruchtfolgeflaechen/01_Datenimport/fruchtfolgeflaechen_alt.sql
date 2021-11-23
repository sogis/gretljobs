select 
    (st_dump(geometrie)).geom as geometrie, 
    case 
        when fffart IN (1,4) 
        then 'geeignet'
        when fffart in (2,6) 
        then 'bedingt_geeignet'
        when fffart = 3
        then 'bedingt_geeignet'
    end as bezeichnung, 
    case when fffart = 4 
         then 'Kiesgrube_Abbaugebiet'
         when fffart = 6 
         then 'Golfplatz'
         when fffart = 3
         then 'reservezone'
         else null 
     end as spezialfall, 
    gem_bfs as bfs_nr, 
    datum_erst::date as datenstand, 
    anrechenbar as anrechenbar, 
    st_area(geometrie)/100 as area_aren, 
    (st_area(geometrie)/100)*anrechenbar as area_anrech
from 
    alw_grundlagen_pub.fruchtfolgeflaechen
