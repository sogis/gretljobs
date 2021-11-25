--Dieser Job vereinigt die verschieden bewerteten FFF. 

drop table if exists alw_fruchtfolgeflaechen.fff_zusammengesetzt;

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
    alw_fruchtfolgeflaechen.fff_zusammengesetzt 
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
    alw_fruchtfolgeflaechen.fff_zusammengesetzt 
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_zusammengesetzt 
where 
    ST_IsEmpty(geometrie)
;

CREATE INDEX IF NOT EXISTS
    fff_zusammengesetzt_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_zusammengesetzt 
    using GIST(geometrie)
;
