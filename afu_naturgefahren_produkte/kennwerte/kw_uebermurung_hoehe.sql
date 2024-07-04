WITH
basket AS (
    SELECT 
        t_id 
    FROM 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO 
    afu_naturgefahren_staging_v1.kennwert_uebermurung_hoehe (
        t_basket, 
        jaehrlichkeit, 
        uebermurungshoehe, 
        prozessquelle, 
        bemerkung, 
        geometrie, 
        datenherkunft, 
        auftrag_neudaten
    )

SELECT 
    basket.t_id AS t_basket, 
    CASE 
    	WHEN hoehe.jaehrlichkeit = 'j_30' 
        THEN 30
    	WHEN hoehe.jaehrlichkeit = 'j_100' 
        THEN 100
    	WHEN hoehe.jaehrlichkeit = 'j_300' 
        THEN 300
    	WHEN hoehe.jaehrlichkeit = 'restgefaehrdung' 
        THEN -1 
    END AS jaehrlichkeit,
    hoehe.h AS fliesshoehe, 
    quelle.kennung AS prozessquelle, 
    hoehe.bemerkung, 
    hoehe.geometrie, 
    'Neudaten' AS datenherkunft, 
    basket_orig.attachmentkey AS auftrag_neudaten
FROM 
    basket,
    afu_naturgefahren_v1.kennwertuebermurungfliesstiefe hoehe
LEFT JOIN 
    afu_naturgefahren_v1.prozessquelle quelle
    ON 
    hoehe.prozessquelle_r = quelle.t_id 
LEFT JOIN
    afu_naturgefahren_v1.t_ili2db_basket basket_orig
    ON 
    hoehe.t_basket = basket_orig.t_id 
;