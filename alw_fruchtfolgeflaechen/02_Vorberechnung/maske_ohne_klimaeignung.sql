DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_maske_ohne_klimaeignung
;

WITH klimaeignung AS (
    SELECT 
        st_union(geometrie) AS geometrie
    FROM 
        klimaeignung.klimaeignung_klima_area klima_area
    LEFT JOIN 
        klimaeignung.kategorien_eignung eignung
        ON 
        klima_area.eignung = eignung .t_id 
    WHERE 
        eignung.klimeigid >41
)

SELECT 
    st_difference(ohne_altlasten.geometrie,klimaeignung.geometrie) AS geometrie
INTO 
    alw_fruchtfolgeflaechen.fff_maske_ohne_klimaeignung 
FROM 
    alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten ohne_altlasten,
    klimaeignung
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_klimaeignung_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_klimaeignung
USING GIST(geometrie)
;
