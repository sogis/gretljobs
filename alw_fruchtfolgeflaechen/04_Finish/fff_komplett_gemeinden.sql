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

--ALLGEMEINE BEREINIGUNGS FUNKTIONEN

update 
    alw_fruchtfolgeflaechen.fff_komplett_gemeinden
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_komplett_gemeinden
where 
    ST_IsEmpty(geometrie)
;

delete from 
    alw_fruchtfolgeflaechen.fff_komplett_gemeinden
where 
    st_geometrytype(geometrie) = 'ST_LineString'
    or 
    st_geometrytype(geometrie) = 'ST_Point'
;

update 
    alw_fruchtfolgeflaechen.fff_komplett_gemeinden
    set 
    geometrie = ST_RemoveRepeatedPoints(geometrie) 
;
