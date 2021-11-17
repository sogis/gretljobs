drop table if exists alw_fruchtfolgeflaechen.fff_komplett;

with buffered_polygons as (
    select 
        st_buffer(geometrie,1) as geometrie, 
        spezialfall, 
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
    from 
        alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
    where 
        st_Area(geometrie) > 15
), 
 
small_polygons as (
    select 
        geometrie, 
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
    from 
        alw_fruchtfolgeflaechen.fff_mit_uebersteuerung 
    where 
        st_Area(geometrie) <= 15
),
 
smallpolygons_attribute_big as (
    select distinct on (small.geometrie)
        small.geometrie, 
        big.spezialfall,
        big.bezeichnung,
        big.beschreibung,
        big.datenstand,
        big.anrechenbar
    from 
        small_polygons small, 
        buffered_polygons big 
    where 
        st_dwithin(small.geometrie,big.geometrie,0)
), 

small_and_big_union as (
    select 
        st_buffer(geometrie,0.5) as geometrie, 
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
    from 
        alw_fruchtfolgeflaechen.fff_mit_uebersteuerung 
    where 
        st_Area(geometrie) > 15
    
    union all 
    
    select 
        st_buffer(geometrie,0.5) as geometrie, 
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
    from 
        smallpolygons_attribute_big
), 

st_union_all_polygons as (
    select 
        st_buffer(st_union(geometrie),-0.5) as geometrie, 
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
    from 
        small_and_big_union
    group by 
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
)

select 
    (st_dump(geometrie)).geom as geometrie, 
    spezialfall,
    bezeichnung,
    beschreibung,
    datenstand,
    anrechenbar
into 
    alw_fruchtfolgeflaechen.fff_komplett
from 
    st_union_all_polygons
;

delete from 
    alw_fruchtfolgeflaechen.fff_komplett
where 
    st_area(geometrie) <= 15
;

CREATE INDEX IF NOT EXISTS
    fff_komplett_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_komplett
    using GIST(geometrie)
;