WITH
basket AS (
     SELECT 
         t_id 
     FROM 
         afu_naturgefahren_staging_v1.t_ili2db_basket
) 

,attribute_mapping AS (
    SELECT 
        'stein_blockschlag' as teilprozess, 
        CASE 
            WHEN gef_stufe = 'keine' 
            THEN 'nicht_gefaehrdet'
    	    WHEN gef_stufe = 'vorhanden' 
            THEN 'restgefaehrdung'
            WHEN gef_stufe = 'gering' 
            THEN 'gering'
            WHEN gef_stufe = 'mittel' 
            THEN 'mittel' 
            WHEN gef_stufe = 'erheblich'
            THEN 'erheblich'
        END AS gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        ST_Multi(geometrie) as geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_sturz
    WHERE 
        prozessa = 'Stein_Blockschlag'
        AND 
        publiziert is true
)

INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_stein_blockschlag (
    t_basket,
    teilprozess, 
    gefahrenstufe, 
    charakterisierung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)
 SELECT
    basket.t_id as t_basket, 
    teilprozess,
    gefahrenstufe,
    charakterisierung,
    geometrie, 
    'Altdaten' as datenherkunft,
    null as auftrag_neudaten
FROM 
    attribute_mapping,
    basket basket
WHERE 
    teilprozess is not null 
;