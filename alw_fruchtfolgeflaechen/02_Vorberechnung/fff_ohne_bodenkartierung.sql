drop table if exists alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung;

select 
    st_intersection(maske.geometrie,alte_fff.geometrie,0.001) as geometrie, 
    alte_fff.anrechenbar,
    alte_fff.spezialfall,
    maske.bfs_nr, 
    alte_fff.bezeichnung, 
    alte_fff.datenstand
into 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
from 
    alw_fruchtfolgeflaechen.fff_maske_where_not_bodenkartierung maske, 
    alw_fruchtfolgeflaechen_alt.inventarflaechen_fruchtfolgeflaeche alte_fff
where 
    st_intersects(maske.geometrie,alte_fff.geometrie)
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
where 
    ST_IsEmpty(geometrie)
;

delete from 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
where 
    st_geometrytype(geometrie) in ('ST_MultiLineString','ST_LineString','ST_Point')
;

CREATE INDEX IF NOT EXISTS
    fff_ohne_bodenkartierung_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
    using GIST(geometrie)
;

-- Neue Flächen in Gebieten ohne Bodenkartierung und ohne alte FFF darunter 

--drop table if exists alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung_ohne_bewertung;

--with alte_fff as (
--    select 
--        st_union(geometrie) as geometrie
--    from 
--        alw_fruchtfolgeflaechen_alt.inventarflaechen_fruchtfolgeflaeche
--)

--select 
--    (st_dump(st_difference(maske.geometrie,alte_fff.geometrie))).geom as geometrie
--into 
--    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung_ohne_bewertung
--from 
--    alw_fruchtfolgeflaechen.fff_maske_where_not_bodenkartierung maske, 
--    alte_fff
--;

--delete from alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung_ohne_bewertung
--where st_area(geometrie)<1000
--;
