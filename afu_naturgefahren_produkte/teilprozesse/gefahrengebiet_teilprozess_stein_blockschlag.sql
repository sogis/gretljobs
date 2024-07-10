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

,teilprozess_steinblockschlag AS ( 
    SELECT 
       'stein_blockschlag' AS teilprozess,
        CASE WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 'restgefaehrdung' 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'gelb' THEN 'gering' 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'blau' THEN 'mittel' 
             WHEN
             (string_to_array(iwcode, '_'))[1] = 'rot' THEN 'erheblich'
        END AS gefahrenstufe,
        CASE WHEN 
             (string_to_array(iwcode, '_'))[2] = 'schwach' AND (string_to_array(iwcode, '_'))[3] = '30' THEN 3
             WHEN
             (string_to_array(iwcode, '_'))[2] = 'schwach' AND (string_to_array(iwcode, '_'))[3] = '100' THEN 2
             WHEN
             (string_to_array(iwcode, '_'))[2] = 'schwach' AND (string_to_array(iwcode, '_'))[3] = '300' THEN 1
             WHEN 
             (string_to_array(iwcode, '_'))[2] = 'mittel' AND (string_to_array(iwcode, '_'))[3] = '30' THEN 6
             WHEN 
             (string_to_array(iwcode, '_'))[2] = 'mittel' AND (string_to_array(iwcode, '_'))[3] = '100' THEN 5
             WHEN 
             (string_to_array(iwcode, '_'))[2] = 'mittel' AND (string_to_array(iwcode, '_'))[3] = '300' THEN 4
             WHEN 
             (string_to_array(iwcode, '_'))[2] = 'stark' AND (string_to_array(iwcode, '_'))[3] = '30' THEN 9
             WHEN 
             (string_to_array(iwcode, '_'))[2] = 'stark' AND (string_to_array(iwcode, '_'))[3] = '100' THEN 8
             WHEN 
             (string_to_array(iwcode, '_'))[2] = 'stark' AND (string_to_array(iwcode, '_'))[3] = '300' THEN 7  
             WHEN 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' THEN 0 --Restgefährdung hat immer die niedrigste Prio  
        END AS charakterisierung,
        geometrie, 
        'Neudaten' AS datenherkunft,
        basket.attachmentkey AS auftrag_neudaten
    FROM 
        afu_naturgefahren_v1.befundsteinblockschlag befund
    LEFT JOIN
        afu_naturgefahren_v1.t_ili2db_basket basket
        ON 
        befund.t_basket = basket.t_id 
    WHERE 
        befund.t_basket in (SELECT t_id FROM orig_basket)
)

,teilprozess_steinblockschlag_prio AS (
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
        teilprozess_steinblockschlag AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_steinblockschlag AS b
        WHERE 
            a.geometrie && b.geometrie 
            AND 
            a.charakterisierung < b.charakterisierung              
    ) AS blade
)

,teilprozess_steinblockschlag_union AS (
    SELECT 
        teilprozess,
        gefahrenstufe,
        charakterisierung,
        st_union(geometrie) AS geometrie,
        datenherkunft,
        auftrag_neudaten
    FROM 
        teilprozess_steinblockschlag_prio
    group by 
        teilprozess,
        gefahrenstufe,
        charakterisierung,
        datenherkunft,
        auftrag_neudaten
)

,teilprozess_steinblockschlag_dump AS (
    SELECT 
        teilprozess,
        gefahrenstufe,
        charakterisierung,
        st_multi((st_dump(geometrie)).geom) AS geometrie,
        datenherkunft,
        auftrag_neudaten
    FROM 
        teilprozess_steinblockschlag_union
) 

,basket AS (
    SELECT 
        t_id 
    FROM 
        afu_naturgefahren_staging_v1.t_ili2db_basket
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
    basket.t_id AS t_basket, 
    teilprozess,
    gefahrenstufe AS gefahrenstufe,
    CASE 
    	WHEN gefahrenstufe = 'restgefaehrdung'
    	THEN 'RG' 
    	ELSE 'S'||charakterisierung
    END AS charakterisierung,
    geometrie, 
    datenherkunft,
    auftrag_neudaten
FROM 
    teilprozess_steinblockschlag_dump, 
    basket
WHERE 
    ST_Isempty(geometrie) is not true 
;