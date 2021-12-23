drop table if exists alw_fruchtfolgeflaechen.fff_mit_gewaesserraum;

with gewaesserraum as (
    SELECT 
        (st_dump(st_intersection(gewaesserraum.geometrie,st_makevalid(fff.geometrie)))).geom as geometrie, 
        'Gewaesserraum' as spezialfall,
        fff.bezeichnung,
        fff.beschreibung,
        fff.datenstand, 
        fff.anrechenbar
    from 
        alw_gewaesserraum.gewaesserraum, 
        alw_fruchtfolgeflaechen.fff_mit_uebersteuerung fff
    where 
        st_intersects(gewaesserraum.geometrie,fff.geometrie)
        AND 
        gewaesserraum.fff_massgebend is true
), 

gewaesserraum_geometrie as (
    select 
        st_union(geometrie) as geometrie
    from 
        alw_gewaesserraum.gewaesserraum
    WHERE 
        gewaesserraum.fff_massgebend is true
),

union_gewaesserraum as (
    select 
        st_difference(st_makevalid(fff.geometrie),gewaesserraum_geometrie.geometrie,0.001) as geometrie, 
        fff.spezialfall, 
        fff.bezeichnung, 
        fff.beschreibung, 
        fff.datenstand, 
        fff.anrechenbar
    from 
        alw_fruchtfolgeflaechen.fff_mit_uebersteuerung fff, 
        gewaesserraum_geometrie

        union all 
-- die "geeigneten Übersteuerungsflächen" werden wieder eingefügt.    
    select 
        st_snaptogrid(geometrie,0.001) as geometrie,
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand, 
        anrechenbar 
    from 
        gewaesserraum
)

select 
    (st_dump(geometrie)).geom as geometrie,
    spezialfall,
    bezeichnung,
    beschreibung,
    datenstand, 
    anrechenbar 
into 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
from 
    union_gewaesserraum
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
where 
    ST_IsEmpty(geometrie)
;

delete from 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
where 
    st_geometrytype(geometrie) = 'ST_LineString'
;

CREATE INDEX IF NOT EXISTS
    fff_mit_gewaesserraum_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
    using GIST(geometrie)
;
