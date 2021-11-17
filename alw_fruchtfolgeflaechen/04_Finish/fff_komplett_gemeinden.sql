drop table if exists alw_fruchtfolgeflaechen.fff_komplett_gemeinden;

select 
    st_intersection(fff.geometrie,gemeinden.geometrie) as geometrie, 
    fff.spezialfall, 
    fff.bezeichnung, 
    fff.beschreibung, 
    fff.datenstand, 
    fff.anrechenbar, 
    gemeinden.bfs_nr, 
    gemeinden.gemeindename 
into 
    alw_fruchtfolgeflaechen.fff_komplett_gemeinden
from 
    alw_fruchtfolgeflaechen.fff_komplett fff,
    agi_mopublic_pub.mopublic_gemeindegrenze gemeinden
where 
    st_intersects(fff.geometrie,gemeinden.geometrie)
;
