DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_maske_ohne_auen_flachmoore_hochmoore_vogelreservate
;

WITH auen_flachmoore_hochmoore_vogelreservate AS (
    SELECT 
        ST_union(geometrie) AS geometrie 
    FROM (
             (
                  SELECT 
                      geometrie 
                  FROM 
                      auen.auen_standorte
                  WHERE 
                      ST_intersects(geometrie,(SELECT geometrie FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze)) --Es interessiren nur die Standorte innerhalb der kantonalen Grenzen
             )
             UNION ALL 
             (
                  SELECT 
                      geometrie 
                  FROM 
                      flachmoore.flachmoore_standorte
                  WHERE 
                      ST_intersects(geometrie,(SELECT geometrie FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze)) --Es interessiren nur die Standorte innerhalb der kantonalen Grenzen
             )
             UNION ALL 
             (
                  SELECT 
                      geometrie 
                  FROM 
                      hochmoore.hochmoore_standorte
                  WHERE 
                      ST_intersects(geometrie,(SELECT geometrie FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze)) --Es interessiren nur die Standorte innerhalb der kantonalen Grenzen
             )
         ) standorte
)

SELECT 
    ST_difference(ohne_klimaeignung.geometrie,auen_flachmoore_hochmoore_vogelreservate.geometrie) AS geometrie 
INTO 
    alw_fruchtfolgeflaechen.fff_maske_ohne_auen_flachmoore_hochmoore_vogelreservate 
FROM 
    alw_fruchtfolgeflaechen.fff_maske_ohne_klimaeignung ohne_klimaeignung,
    auen_flachmoore_hochmoore_vogelreservate
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_auen_flachmoore_hochmoore_vogelreservate_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_auen_flachmoore_hochmoore_vogelreservate
USING GIST(geometrie)
;
