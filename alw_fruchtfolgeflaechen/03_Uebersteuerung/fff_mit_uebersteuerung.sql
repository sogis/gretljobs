drop table if exists alw_fruchtfolgeflaechen.fff_mit_uebersteuerung;

--Alle Übersteuerungsflächen werden ausgeschnitten 
with uebersteuerung as (
    select 
        st_buffer(st_buffer(st_buffer(st_buffer(st_union(geometrie),0.01),-0.01),-0.01),0.01) as geometrie
    from 
        alw_fff_uebersteuerung.uebersteuerung
), 

union_uebersteuerung as (
    select 
        st_difference(fff_all_together.geometrie,uebersteuerung.geometrie,0.01) as geometrie, 
        fff_all_together.spezialfall, 
        fff_all_together.bezeichnung, 
        null as beschreibung, 
        now() as datenstand, 
        fff_all_together.anrechenbar
    from 
        alw_fruchtfolgeflaechen.fff_all_together fff_all_together, 
        uebersteuerung

        union all 
-- die "geeigneten Übersteuerungsflächen" werden wieder eingefügt.    
    select 
        geometrie,
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand, 
        anrechenbar 
    from 
        alw_fff_uebersteuerung.uebersteuerung
    where 
        bezeichnung = 'geeignete_FFF'
)

select 
    (st_dump(geometrie)).geom as geometrie,
    spezialfall,
    bezeichnung,
    beschreibung,
    datenstand, 
    anrechenbar 
into 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
from 
    union_uebersteuerung
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
where 
    ST_IsEmpty(geometrie)
;

delete from 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
where 
    st_geometrytype(geometrie) = 'ST_LineString'
;

CREATE INDEX IF NOT EXISTS
    fff_mit_uebersteuerung_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
    using GIST(geometrie)
;
