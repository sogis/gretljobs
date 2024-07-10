WITH
basket AS (
     SELECT 
         t_id 
     FROM 
         afu_naturgefahren_staging_v1.t_ili2db_basket
)

,hauptprozess_alt_wasser_prio AS (
    SELECT 
        'wasser' AS hauptprozess, 
        CASE 
            WHEN gef_stufe = 'vorhanden' 
            THEN 'restgefaehrdung'
            WHEN gef_stufe = 'gering' 
            THEN 'gering'
            WHEN gef_stufe = 'mittel' 
            THEN 'mittel' 
            WHEN gef_stufe = 'erheblich' 
            THEN 'erheblich'
        END AS gefahrenstufe, 
        replace(aindex, '_', '') AS charakterisierung, 
        geometrie,
        CASE 
            WHEN gef_stufe = 'vorhanden' 
            THEN 0 
            WHEN gef_stufe = 'gering' 
            THEN 1 
            WHEN gef_stufe = 'mittel' 
            THEN 2 
            WHEN gef_stufe = 'erheblich' 
            THEN 3
        END || regexp_replace(aindex, '\D','','g') AS prio --Die Prio setzt sich zusammen aus gef_stufe und Nummer der Charakterisierung. Grund: Geteilte Kästchen! 
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_wasser
    WHERE 
        publiziert is true
        AND 
        gef_stufe != 'keine'
)

,hauptprozess_alt_wasser_prio_clip AS (
    SELECT 
        a.hauptprozess,
        a.gefahrenstufe,
        a.charakterisierung, 
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
    FROM  
        hauptprozess_alt_wasser_prio AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            hauptprozess_alt_wasser_prio AS b
        WHERE 
            a.geometrie && b.geometrie 
            AND 
            a.prio < b.prio              
    ) AS blade		
)

,hauptprozess_alt_wasser_union AS (
    SELECT 
        hauptprozess,
        gefahrenstufe,
        charakterisierung,
        ST_union(geometrie) AS geometrie
    FROM 
        hauptprozess_alt_wasser_prio_clip
    GROUP BY 
        hauptprozess,
        gefahrenstufe,
        charakterisierung 
)

,hauptprozess_wasser_dump AS (
    SELECT 
        hauptprozess,
        gefahrenstufe,
        charakterisierung,
        (ST_dump(geometrie)).geom AS geometrie
    FROM 
        hauptprozess_alt_wasser_union
)

INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser (
    t_basket,
    hauptprozess, 
    gefahrenstufe, 
    charakterisierung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id AS t_basket,
    hauptprozess,
    gefahrenstufe, 
    charakterisierung, 
    ST_multi(geometrie) AS geometrie, --Im neuen Modell sind Multi-Polygone
    'Altdaten' AS datenherkunft, 
    null AS auftrag_neudaten
FROM 
    hauptprozess_wasser_dump,
    basket
;