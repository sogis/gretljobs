DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten
;

WITH altlasten AS (
    SELECT 
        ST_union(geometrie) AS geometrie
    FROM 
        afu_altlasten_pub.belastete_standorte_altlast4web 
    WHERE 
        c_bere_res_abwbewe IN ('02','03','04','05','06','SO05')
)

SELECT 
    ST_difference(fff_bodenbedeckung.geometrie,altlasten.geometrie) AS geometrie
INTO 
    alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten 
FROM 
    alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung fff_bodenbedeckung,
    altlasten
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_altlasten_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten
USING GIST(geometrie)
;
