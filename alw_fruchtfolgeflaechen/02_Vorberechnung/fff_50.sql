drop table if exists alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50;

with bedingt_geeigneter_boden as (
    select 
        geometrie as geometrie
    from 
        afu_isboden_pub.bodeneinheit
    where
        (
            gelform IN ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n')
            AND
            skelett_ob IN (0, 1, 2, 3, 4, 5)
            AND
            wasserhhgr IN ('a', 'b', 'c', 'f', 'g', 'k', 'i', 'h', 'm', 'l', 'o', 'q')
            AND
            (pflngr <50 or (pflngr is null and bodpktzahl <70))
        )
        or 
        (
            gelform IN ('k', 'l', 'm', 'n')
            AND
            skelett_ob IN (0, 1, 2, 3, 4, 5)
            AND
            wasserhhgr IN ('a', 'b', 'c', 'f', 'g', 'k', 'i', 'h', 'm', 'l', 'o', 'q')
            AND
            (pflngr >=50 or (pflngr is null and bodpktzahl >=70))
        )
        or 
        (
            gelform IN ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n')
            AND
            skelett_ob IN (0, 1, 2, 3, 4, 5)
            AND
            wasserhhgr IN ('p', 'u', 'w')
            AND
            (
                (pflngr >=30
                 AND
                 pflngr <50
                )
                or 
                (pflngr is null
                 and 
                 bodpktzahl >=50
                )
            )           
        )
        or 
        (
            gelform IN ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n')
            AND
            skelett_ob IN (0, 1, 2, 3, 4, 5)
            AND
            wasserhhgr IN ('d')
            AND
            (
                (pflngr >=40
                 AND
                 pflngr <50
                )
                or 
                (pflngr is null 
                 and 
                 bodpktzahl >=60
                )
            )
        )
    
    union all 

    select 
        ST_intersection(schlechter_boden.geometrie,vereinbarungsflaechen.geometrie) as geometrie
    from 
        alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden schlechter_boden,
        arp_mjpnatur_pub.vereinbrngsflchen_flaechen vereinbarungsflaechen
    where 
        st_intersects(schlechter_boden.geometrie,vereinbarungsflaechen.geometrie)
),  

reserveflaechen as (
    select 
        st_union(geometrie) as geometrie 
    from (
        select 
            st_union(st_snaptogrid(geometrie,0.001)) as geometrie
        from 
            arp_npl_pub.nutzungsplanung_grundnutzung
        where 
            typ_kt = 'N439_Reservezone'
        union all 
        select 
            st_union(apolygon) as geometrie
        from 
            afu_gewaesserschutz_pub.gewaesserschutz_zone_areal
        where 
            typ = 'S2'
        ) unionsgeometrie
-- Grundwasserschutz S2 wird hier auf ausgeschnitten, denn diese Flächen werden mit 0 angerechnet. 
),

ohne_reserveflaechen as (
    select 
        st_difference(boden.geometrie,reserveflaechen.geometrie,0.001) as geometrie
    from 
        bedingt_geeigneter_boden boden, 
        reserveflaechen
)

select 
    st_intersection(st_makevalid(maske.geometrie),ohne_reserveflaechen.geometrie) as geometrie,
    0.5 as anrechenbar, 
    bfs_nr, 
    'bedingt_geeignet'as bezeichnung
into 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
from 
    alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung maske, 
    ohne_reserveflaechen 
where 
    st_intersects(maske.geometrie,ohne_reserveflaechen.geometrie)
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
where 
    ST_IsEmpty(geometrie)
;

CREATE INDEX IF NOT EXISTS
    fff_mit_bodenkartierung_50_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
    using GIST(geometrie)
;
