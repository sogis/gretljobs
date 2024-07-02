-- ACHTUNG: NEUES DATASET UND BASKET MÜSSEN ANGELEGT WORDEN SEIN!!! 
DELETE FROM afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_absenkung_einsturz
;

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

,teilprozess_absenkung_einsturz AS ( 
    SELECT 
       'absenkung' AS teilprozess,
        CASE 
            WHEN (string_to_array(iwcode, '_'))[1] = 'gelb' 
            THEN 'gering' 
            WHEN (string_to_array(iwcode, '_'))[1] = 'blau' 
            THEN 'mittel' 
            WHEN (string_to_array(iwcode, '_'))[1] = 'rot' 
            THEN 'erheblich'
        END AS gefahrenstufe,
        CASE 
            WHEN (string_to_array(iwcode, '_'))[2] = 'schwach' 
            THEN 2
            WHEN (string_to_array(iwcode, '_'))[2] = 'mittel' 
            THEN 5  
        END AS charakterisierung,
        geometrie, 
        'Neudaten' AS datenherkunft,
        basket.attachmentkey AS auftrag_neudaten
    FROM 
        afu_naturgefahren_v1.befundabsenkung befund
    LEFT JOIN
        afu_naturgefahren_v1.t_ili2db_basket basket
        ON 
        befund.t_basket = basket.t_id 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
        
    UNION ALL

    SELECT 
       'einsturz' AS teilprozess,
        CASE 
            WHEN (string_to_array(iwcode, '_'))[1] = 'gelb' 
            THEN 'gering' 
            WHEN (string_to_array(iwcode, '_'))[1] = 'blau' 
            THEN 'mittel' 
            WHEN (string_to_array(iwcode, '_'))[1] = 'rot' 
            THEN 'erheblich'
        END AS gefahrenstufe,
        CASE 
            WHEN (string_to_array(iwcode, '_'))[2] = 'schwach' 
            THEN 2
            WHEN (string_to_array(iwcode, '_'))[2] = 'mittel' 
            THEN 5  
        END AS charakterisierung,
        geometrie, 
        'Neudaten' AS datenherkunft,
        basket.attachmentkey AS auftrag_neudaten
    FROM 
        afu_naturgefahren_v1.befundeinsturz befund
    LEFT JOIN
        afu_naturgefahren_v1.t_ili2db_basket basket
        ON 
        befund.t_basket = basket.t_id 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
)

,teilprozess_absenkung_einsturz_prio AS (
    SELECT 
        a.teilprozess,
        a.gefahrenstufe,
        a.charakterisierung,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie, 
        a.datenherkunft,
        a.auftrag_neudaten
    FROM  
        teilprozess_absenkung_einsturz AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_absenkung_einsturz AS b
        WHERE 
            a.geometrie && b.geometrie 
            AND 
            a.charakterisierung < b.charakterisierung              
    ) AS blade
)

,teilprozess_absenkung_einsturz_union AS (
    SELECT 
        teilprozess,
        gefahrenstufe,
        charakterisierung,
        ST_union(geometrie) AS geometrie,
        datenherkunft,
        auftrag_neudaten
    FROM 
        teilprozess_absenkung_einsturz_prio
    group by 
        teilprozess,
        gefahrenstufe,
        charakterisierung,
        datenherkunft,
        auftrag_neudaten
)

,teilprozess_absenkung_einsturz_dump AS (
    SELECT 
        teilprozess,
        gefahrenstufe,
        charakterisierung,
        ST_multi((st_dump(geometrie)).geom) AS geometrie,
        datenherkunft,
        auftrag_neudaten
    FROM 
        teilprozess_absenkung_einsturz_union
) 

,basket AS (
    SELECT 
        t_id 
    FROM 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_absenkung_einsturz (
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
    'A'||charakterisierung AS charakterisierung,
    geometrie, 
    datenherkunft,
    auftrag_neudaten
FROM 
    teilprozess_absenkung_einsturz_dump, 
    basket
WHERE 
    ST_isempty(geometrie) is not true 
;



