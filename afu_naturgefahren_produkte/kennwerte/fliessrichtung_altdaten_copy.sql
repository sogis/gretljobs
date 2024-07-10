WITH 
basket AS (
    SELECT 
        t_id,
        attachmentkey
    FROM 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO afu_naturgefahren_staging_v1.fliessrichtung (
    t_basket,
    jaehrlichkeit, 
    fliessrichtung, 
    prozessquelle_neudaten, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id as t_basket, 
    CASE 
    	WHEN wkp = 'von_0_bis_30_Jahre' 
        THEN '30' 
    	WHEN wkp = 'von_30_bis_100_Jahre' 
        THEN '100' 
    	WHEN wkp = 'von_100_bis_300_Jahre' 
        THEN '300' 
    END AS jaehrlichkeit, 
    fliessr AS fliessrichtung, 
    null AS prozessquelle_neudaten, 
    geometrie, 
    'Altdaten' AS datenherkunft,
    basket.attachmentkey AS auftrag_neudaten
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_punktsignatur signatur,
    basket 
WHERE 
    art = 'Fliessrichtung'
;