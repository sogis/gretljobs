DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_maske_ohne_naturreservate
;

WITH naturreservate AS ( 
    SELECT 
        ST_union(geometrie) AS geometrie
    FROM 
        arp_naturreservate_pub.naturreservate_reservat
)

SELECT 
    ST_difference(ohne_trockenwiesen.geometrie,naturreservate.geometrie) AS geometrie 
INTO
    alw_fruchtfolgeflaechen.fff_maske_ohne_naturreservate 
FROM 
    alw_fruchtfolgeflaechen.fff_maske_ohne_trockenwiesen ohne_trockenwiesen,
    naturreservate
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_naturreservate_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_naturreservate
USING GIST(geometrie)
;
