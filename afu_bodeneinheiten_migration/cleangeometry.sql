UPDATE 
    afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_landwirtschaft
    SET 
    geometrie = st_reduceprecision(geometrie,0.001)
;

UPDATE 
    afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_wald
    SET 
    geometrie = st_reduceprecision(geometrie,0.001)
;


WITH cleaned AS (
    SELECT
        t_id,
        ST_CoverageClean(geometrie) OVER () AS geometrie_clean
    FROM afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_landwirtschaft
)
UPDATE afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_landwirtschaft AS t
SET geometrie = c.geometrie_clean
FROM cleaned AS c
WHERE t.t_id = c.t_id
;

WITH cleaned AS (
    SELECT
        t_id,
        ST_CoverageClean(geometrie) OVER () AS geometrie_clean
    FROM afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_wald
)
UPDATE afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_wald AS t
SET geometrie = c.geometrie_clean
FROM cleaned AS c
WHERE t.t_id = c.t_id
;
