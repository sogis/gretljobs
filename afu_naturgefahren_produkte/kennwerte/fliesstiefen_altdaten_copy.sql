WITH 
basket AS (
    SELECT 
        t_id,
        attachmentkey
    FROM 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO afu_naturgefahren_staging_v1.fliesstiefen (
    t_basket, 
    jaehrlichkeit, 
    ueberschwemmung_tiefe, 
    prozessquelle_neudaten, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id AS t_basket,
    CASE 
    	WHEN tiefe.wkp = 'von_0_bis_30_Jahre' 
        THEN '30'
    	WHEN tiefe.wkp = 'von_30_bis_100_Jahre' 
        THEN '100'
    	WHEN tiefe.wkp = 'von_100_bis_300_Jahre'
        THEN '300'
    END AS jaehrlichkeit,  
    tiefe.ueberfl_hb AS ueberschwemmung_tiefe, 
    null AS prozessquelle_neudaten, 
    ST_Multi(tiefe.geometrie) AS geometrie, 
    'Altdaten' AS datenherkunft,
    null AS auftrag_neudaten
FROM 
    basket,
    afu_gefahrenkartierung.gefahrenkartirung_ueberflutungskarte tiefe
WHERE 
    ueberfl_hb != 'keine_Ueberflutung'
;
