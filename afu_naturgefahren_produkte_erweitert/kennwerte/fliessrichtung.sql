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
    basket.t_id AS t_basket, 
    CASE 
    	WHEN richtung.jaehrlichkeit = 'j_30' 
        THEN '30'
    	WHEN richtung.jaehrlichkeit = 'j_100' 
        THEN '100'
    	WHEN richtung.jaehrlichkeit = 'j_300' 
        THEN '300'
    	WHEN richtung.jaehrlichkeit = 'restgefaehrdung' 
        THEN '-1' 
    END AS jaehrlichkeit, 
    richtung.azimuth::integer AS fliessrichtung, 
    prozessquelle.kennung AS prozessquelle_neudaten, 
    geometrie, 
    'Neudaten' AS datenherkunft,
    basket.attachmentkey AS auftrag_neudaten
FROM 
    basket,
    afu_naturgefahren_v1.fliessrichtungspfeil richtung
LEFT JOIN  
    afu_naturgefahren_v1.prozessquelle prozessquelle 
    on 
    richtung.prozessquelle_r = prozessquelle.t_id
WHERE 
    richtung.t_basket in (SELECT t_id FROM orig_basket)
;
