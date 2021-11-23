drop table if exists alw_fruchtfolgeflaechen.fff_all_together;

with alle_zusammen as (
select 
    geometrie, 
    bfs_nr,
    anrechenbar,
    bezeichnung, 
    spezialfall 
from 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_0
where 
    st_geometrytype(geometrie) IN ('ST_Polygon', 'ST_MultiPolygon')
    
union all 

select 
    geometrie, 
    bfs_nr,
    anrechenbar,
    bezeichnung, 
    null as spezialfall 
from 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
where 
    st_geometrytype(geometrie) IN ('ST_Polygon', 'ST_MultiPolygon')
    
union all 

select 
    geometrie, 
    bfs_nr,
    anrechenbar,
    'geeignet' as bezeichnung, 
    null as spezialfall 
from 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
where 
    st_geometrytype(geometrie) IN ('ST_Polygon', 'ST_MultiPolygon')

union all 

select 
    geometrie, 
    bfs_nr,
    anrechenbar,
    bezeichnung, 
    spezialfall 
from 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
where 
    st_geometrytype(geometrie) IN ('ST_Polygon', 'ST_MultiPolygon')
)

--Das Union hier bezweckt das verbinden gleicher Flächen (gleiche wertigkeit und bfs_nr etc.)
select 
    st_makevalid(st_buffer(st_buffer(st_union(geometrie),1),-1)) as geometrie, 
    bfs_nr,
    anrechenbar,
    bezeichnung, 
    spezialfall 
into 
    alw_fruchtfolgeflaechen.fff_all_together 
from 
    alle_zusammen 
group by 
    bfs_nr,
    anrechenbar,
    bezeichnung,
    spezialfall 
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_all_together
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_all_together
where 
    ST_IsEmpty(geometrie)
;

CREATE INDEX IF NOT EXISTS
    fff_all_together_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_all_together
    using GIST(geometrie)
;
