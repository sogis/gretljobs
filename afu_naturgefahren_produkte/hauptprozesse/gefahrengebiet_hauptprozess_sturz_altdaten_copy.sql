WITH
basket AS (
     SELECT 
         t_id 
     FROM 
         afu_naturgefahren_staging_v1.t_ili2db_basket
)    

INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz (
    t_basket, 
    hauptprozess, 
    gefahrenstufe, 
    charakterisierung, 
    teilprozess,
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id as t_basket,
    'sturz' as hauptprozess,
     CASE 
    	WHEN gef_stufe = 'vorhanden' THEN 'restgefaehrdung'
    	WHEN gef_stufe = 'gering' THEN 'gering'
    	WHEN gef_stufe = 'mittel' THEN 'mittel' 
    	WHEN gef_stufe = 'erheblich' THEN 'erheblich'
    end as gefahrenstufe, 
    replace(aindex, '_', '') as charakterisierung, 
    CASE 
        WHEN prozessa = 'Stein_Blockschlag' THEN 'stein_blockschlag'
        WHEN prozessa = 'Felssturz' THEN 'fels_bergsturz'
    END AS teilprozess,    
    ST_multi(geometrie) as geometrie, --Im neuen Modell sind Multi-Polygone
    'Altdaten' as datenherkunft, 
    null as auftrag_neudaten
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_gk_sturz,
    basket
WHERE 
    publiziert is true
    and 
    gef_stufe != 'keine'
;