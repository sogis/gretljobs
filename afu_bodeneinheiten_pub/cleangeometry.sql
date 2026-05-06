UPDATE 
    afu_bodeneinheiten_pub_v1.bodeneinheit_landwirtschaft
    SET 
    geometrie = st_reduceprecision(geometrie,0.001)
;

UPDATE 
    afu_bodeneinheiten_pub_v1.bodeneinheit_wald
    SET 
    geometrie = st_reduceprecision(geometrie,0.001)
;


WITH cleaned AS (
    SELECT
        t_id,
        ST_CoverageClean(geometrie) OVER () AS geometrie_clean
    FROM afu_bodeneinheiten_pub_v1.bodeneinheit_landwirtschaft
)
UPDATE afu_bodeneinheiten_pub_v1.bodeneinheit_landwirtschaft AS t
SET geometrie = c.geometrie_clean
FROM cleaned AS c
WHERE t.t_id = c.t_id
;

WITH cleaned AS (
    SELECT
        t_id,
        ST_CoverageClean(geometrie) OVER () AS geometrie_clean
    FROM afu_bodeneinheiten_pub_v1.bodeneinheit_wald
)
UPDATE afu_bodeneinheiten_pub_v1.bodeneinheit_wald AS t
SET geometrie = c.geometrie_clean
FROM cleaned AS c
WHERE t.t_id = c.t_id
;
