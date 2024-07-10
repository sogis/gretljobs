WITH
basket AS (
    SELECT 
        t_id 
    FROM 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO 
    afu_naturgefahren_staging_v1.kennwert_uebermurung_geschwindigkeit (
        t_basket, 
        jaehrlichkeit, 
        fliessgeschwindigkeit, 
        prozessquelle, 
        bemerkung, 
        geometrie, 
        datenherkunft, 
        auftrag_neudaten
    )

SELECT 
    basket.t_id AS t_basket, 
    CASE 
    	WHEN geschwindigkeit.jaehrlichkeit = 'j_30' 
        THEN 30
    	WHEN geschwindigkeit.jaehrlichkeit = 'j_100' 
        THEN 100
    	WHEN geschwindigkeit.jaehrlichkeit = 'j_300' 
        THEN 300
    	WHEN geschwindigkeit.jaehrlichkeit = 'restgefaehrdung' 
        THEN -1 
    END AS jaehrlichkeit,
    geschwindigkeit.v AS fliessgeschwindigkeit, 
    quelle.kennung AS prozessquelle, 
    geschwindigkeit.bemerkung, 
    geschwindigkeit.geometrie, 
    'Neudaten' AS datenherkunft, 
    basket_orig.attachmentkey AS auftrag_neudaten
FROM 
    basket,
    afu_naturgefahren_v1.kennwertuebermurungfliessgeschwindigkeit geschwindigkeit
LEFT JOIN 
    afu_naturgefahren_v1.prozessquelle quelle
    ON 
    geschwindigkeit.prozessquelle_r = quelle.t_id 
LEFT JOIN
    afu_naturgefahren_v1.t_ili2db_basket basket_orig
    ON 
    geschwindigkeit.t_basket = basket_orig.t_id 
