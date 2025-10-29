WITH 
basket AS (
     SELECT 
         t_id,
         attachmentkey
     FROM 
         afu_naturgefahren_staging_v1.t_ili2db_basket
)
 
INSERT INTO afu_naturgefahren_staging_v1.abklaerungsperimeter (
    t_basket,
    teilprozess, 
    erhebungsstand, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id AS t_basket,
    'absenkung' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' AS datenherkunft, 
    NULL AS auftrag_neudaten
FROM 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_absenkung
    ,basket

    UNION ALL 
    
SELECT 
    basket.t_id AS t_basket,
    'einsturz' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' AS datenherkunft, 
    NULL AS auftrag_neudaten
FROM 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_einsturz
    ,basket
    
    UNION ALL 
    
SELECT 
    basket.t_id AS t_basket,
    'fels_bergsturz' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' AS datenherkunft, 
    NULL AS auftrag_neudaten
FROM 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_fels_berg_sturz
    ,basket
    
    UNION ALL 
    
SELECT 
    basket.t_id AS t_basket,
    'hangmure' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' AS datenherkunft, 
    NULL AS auftrag_neudaten
FROM 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_hangmure
    ,basket
    
    UNION ALL 
    
SELECT 
    basket.t_id AS t_basket,
    'permanente_rutschung' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' AS datenherkunft, 
    NULL AS auftrag_neudaten
FROM 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_permanente_rutschung
    ,basket
    
    UNION ALL 
    
SELECT 
    basket.t_id AS t_basket,
    'spontane_rutschung' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' AS datenherkunft, 
    NULL AS auftrag_neudaten
FROM 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_spontane_rutschung
    ,basket
    
    UNION ALL 
    
SELECT 
    basket.t_id AS t_basket,
    'stein_blockschlag' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' AS datenherkunft, 
    NULL AS auftrag_neudaten
FROM 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_stein_block_schlag
    ,basket
    
    UNION ALL 
    
SELECT 
    basket.t_id AS t_basket,
    'uebermurung' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' AS datenherkunft, 
    NULL AS auftrag_neudaten
FROM 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_uebermurung
    ,basket
    
    UNION ALL 
    
SELECT 
    basket.t_id AS t_basket,
    'ueberschwemmung' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' AS datenherkunft, 
    NULL AS auftrag_neudaten
FROM 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_ueberschwemmung
    ,basket
    
    UNION ALL 
    
SELECT 
    basket.t_id AS t_basket,
    'ufererosion' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' AS datenherkunft, 
    NULL AS auftrag_neudaten
FROM 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_ufererosion
    ,basket
;

UPDATE afu_naturgefahren_staging_v1.abklaerungsperimeter
SET geometrie = st_reducePrecision(geometrie,0.001)
;

DELETE FROM afu_naturgefahren_staging_v1.abklaerungsperimeter
WHERE st_isempty(geometrie) = true
; 