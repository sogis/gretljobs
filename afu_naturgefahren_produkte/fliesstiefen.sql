WITH 
orig_dataset AS (
    SELECT
        t_id  AS dataset  
    FROM 
        afu_naturgefahren_v1.t_ili2db_dataset
    WHERE 
        datasetname = ${kennung}
)

,orig_basket AS (
    SELECT 
        basket.t_id 
    FROM 
        afu_naturgefahren_v1.t_ili2db_basket basket,
        orig_dataset
    WHERE 
        basket.dataset = orig_dataset.dataset
        AND 
        topic like '%Befunde'
)

,basket AS (
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
    	WHEN tiefe.jaehrlichkeit = 'j_30' 
        THEN '30'
    	WHEN tiefe.jaehrlichkeit = 'j_100' 
        THEN '100'
    	WHEN tiefe.jaehrlichkeit = 'j_300' 
        THEN '300'
    	WHEN tiefe.jaehrlichkeit = 'restgefaehrdung' 
        THEN '-1' 
    END AS jaehrlichkeit,  
    CASE 
    	WHEN h = 'von_0_bis_25_cm' 
        THEN 'von_0_bis_25cm'
    	WHEN h = 'von_25_bis_50_cm' 
        THEN 'von_25_bis_50cm' 
    	WHEN h = 'von_50_bis_75_cm' 
        THEN 'von_50_bis_75cm' 
    	WHEN h = 'von_75_bis_100_cm' 
        THEN 'von_75_bis_100cm'
    	WHEN h = 'von_100_bis_125_cm' 
        THEN 'von_100_bis_200cm'
    	WHEN h = 'von_125_bis_150_cm' 
        THEN 'von_100_bis_200cm'
    	WHEN h = 'von_150_bis_175_cm' 
        THEN 'von_100_bis_200cm'
    	WHEN h = 'von_175_bis_200_cm' 
        THEN 'von_100_bis_200cm'
    	WHEN h = 'von_200_bis_300_cm' 
        THEN 'groesser_200cm'
    	WHEN h = 'von_300_bis_400_cm' 
        THEN 'groesser_200cm'
    	ELSE 'BERECHNUNGSFEHLER' 
    END AS ueberschwemmung_tiefe, 
    prozessquelle.kennung AS prozessquelle_neudaten, 
    ST_Multi(geometrie) AS geometrie, 
    'Neudaten' AS datenherkunft,
    basket.attachmentkey AS auftrag_neudaten
FROM 
    basket,
    afu_naturgefahren_v1.kennwertueberschwemmungfliesstiefe tiefe
LEFT JOIN 
    afu_naturgefahren_v1.prozessquelle prozessquelle 
    ON 
    tiefe.prozessquelle_r = prozessquelle.t_id
WHERE 
    tiefe.t_basket in (SELECT t_id FROM orig_basket)
;