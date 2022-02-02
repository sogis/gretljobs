DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
;

--Die Vereinbarungsflächen aus dem MJPNatur werden mit der Maske verschnitten. Sie können zu 50% als FFF angerechnet werden. 
WITH vereinbarungsflaechen AS (
    SELECT 
        ST_CollectionExtract(ST_intersection(schlechter_boden.geometrie,vereinbarungsflaechen.geometrie,0.001),3) AS geometrie
    FROM 
        alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden schlechter_boden,
        arp_mjpnatur_pub.vereinbrngsflchen_flaechen vereinbarungsflaechen
    WHERE 
        ST_intersects(schlechter_boden.geometrie,vereinbarungsflaechen.geometrie)
),

bedingt_geeigneter_boden AS (
    SELECT 
        geometrie AS geometrie
    FROM 
        afu_isboden_pub.bodeneinheit
    WHERE
        (
            gelform IN ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n')
            AND
            skelett_ob IN (0, 1, 2, 3, 4, 5)
            AND
            wasserhhgr IN ('a', 'b', 'c', 'f', 'g', 'k', 'i', 'h', 'm', 'l', 'o', 'q')
            AND
            (
                pflngr <50 
                OR 
                (pflngr IS null AND bodpktzahl <70)
            )
        )
        OR 
        (
            gelform IN ('k', 'l', 'm', 'n')
            AND
            skelett_ob IN (0, 1, 2, 3, 4, 5)
            AND
            wasserhhgr IN ('a', 'b', 'c', 'f', 'g', 'k', 'i', 'h', 'm', 'l', 'o', 'q')
            AND
            (
                pflngr >=50 
                OR 
                (pflngr IS null AND bodpktzahl >=70)
            )
        )
        OR 
        (
            gelform IN ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n')
            AND
            skelett_ob IN (0, 1, 2, 3, 4, 5)
            AND
            wasserhhgr IN ('p', 'u', 'w')
            AND
            (
                (pflngr >=30 AND pflngr <50)
                OR 
                (pflngr IS null AND bodpktzahl >=50)
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
                (pflngr >=40 AND pflngr <50)
                OR 
                (pflngr is null AND bodpktzahl >=60)
            )
        )
    
    UNION ALL 

    SELECT 
        geometrie AS geometrie
    FROM  
        vereinbarungsflaechen
)

SELECT 
    (ST_dump(ST_union(ST_intersection(maske.geometrie,bedingt_geeigneter_boden.geometrie,0.001)))).geom AS geometrie,
    0.5 AS anrechenbar, 
    'bedingt_geeignet'AS bezeichnung
INTO 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
FROM 
    alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung maske, 
    bedingt_geeigneter_boden 
WHERE 
    ST_intersects(maske.geometrie,bedingt_geeigneter_boden.geometrie)
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
UPDATE 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
    SET 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    ST_geometrytype(geometrie) = 'ST_GeometryCollection'
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
WHERE 
    ST_IsEmpty(geometrie)
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
WHERE 
    ST_geometrytype(geometrie) IN ('ST_LineString','ST_Point')
;

CREATE INDEX IF NOT EXISTS
    fff_mit_bodenkartierung_50_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
 USING GIST(geometrie)
;
