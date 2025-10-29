WITH
basket AS (
     SELECT 
         t_id 
     FROM 
         afu_naturgefahren_staging_v1.t_ili2db_basket
) 

,attribute_mapping AS (
    SELECT 
        'permanente_rutschung' AS teilprozess, 
        CASE 
            WHEN gef_stufe = 'keine' THEN 'nicht_gefaehrdet'
    	    WHEN gef_stufe = 'vorhanden' THEN 'restgefaehrdung'
            WHEN gef_stufe = 'gering' THEN 'gering'
            WHEN gef_stufe = 'mittel' THEN 'mittel' 
            WHEN gef_stufe = 'erheblich' THEN 'erheblich'
        end AS gefahrenstufe, 
        replace(aindex, '_', '') AS charakterisierung, 
        ST_Multi(geometrie) AS geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_kont_sackung
    WHERE 
        publiziert is true
)

INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_permanente_rutschung (
    t_basket,
    teilprozess, 
    gefahrenstufe, 
    charakterisierung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

 SELECT
    basket.t_id AS t_basket, 
    teilprozess,
    gefahrenstufe,
    charakterisierung,
    geometrie, 
    'Altdaten' AS datenherkunft,
    null AS auftrag_neudaten
FROM 
    attribute_mapping,
    basket basket
;


