DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_maske_ohne_trockenwiesen
;

WITH trockenwiese AS ( 
    SELECT 
        ST_union(geometrie) AS geometrie
    FROM 
        trockenwiesenweiden.trockenwiesenwden_standorte
    WHERE 
        ST_intersects(geometrie,(SELECT geometrie FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze))
)

SELECT 
  CASE
    WHEN trockenwiese.geometrie IS NULL THEN ohne_bauzonen.geometrie
    ELSE ST_difference(ohne_bauzonen.geometrie,trockenwiese.geometrie)
  END AS geometrie
INTO 
    alw_fruchtfolgeflaechen.fff_maske_ohne_trockenwiesen 
FROM 
    alw_fruchtfolgeflaechen.fff_maske_ohne_bauzonen ohne_bauzonen,
    trockenwiese
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_trockenwiesen_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_trockenwiesen
USING GIST(geometrie)
;
