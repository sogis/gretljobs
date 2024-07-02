WITH 
basket AS (
    SELECT 
        t_id,
        attachmentkey
    FROM 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO afu_naturgefahren_staging_v1.ufererosion (
    t_basket,
    teilprozess, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id as t_basket, 
    'ufererosion' as teilprozess, 
    ST_Multi(geometrie) as geometrie, 
    'Neudaten' as datenherkunft, 
    basket.attachmentkey as auftrag_neudaten
FROM 
    afu_naturgefahren_v1.befundufererosion ufererosion,
    basket 
;