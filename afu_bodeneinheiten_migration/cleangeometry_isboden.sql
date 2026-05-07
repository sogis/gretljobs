UPDATE 
    afu_isboden.bodeneinheit_t
    SET 
    wkb_geometry = st_reduceprecision(wkb_geometry,0.001)
;

WITH cleaned AS (
    SELECT
        pk_ogc_fid,
        ST_CoverageClean(wkb_geometry) OVER () AS geometrie_clean
    FROM afu_isboden.bodeneinheit_t
)
UPDATE afu_isboden.bodeneinheit_t AS t
SET wkb_geometry = st_setsrid(c.geometrie_clean,2056)
FROM cleaned AS c
WHERE t.pk_ogc_fid = c.pk_ogc_fid
;