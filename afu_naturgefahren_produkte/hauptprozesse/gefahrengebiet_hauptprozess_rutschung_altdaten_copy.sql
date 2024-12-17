WITH
attribute_mapping_hangmure AS (
    SELECT 
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
        'hangmure' as teilprozess,
        ST_multi(geometrie) AS geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_hangmure
    WHERE 
        publiziert = true 
        AND 
        gef_stufe != 'keine'
) 

,attribute_mapping_plo_rutschung AS (
    SELECT 
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
        'spontane_rutschung' AS teilprozess,
        ST_multi(geometrie) AS geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_spontan
    WHERE 
        publiziert = true 
        AND 
        gef_stufe != 'keine'
)

,attribute_mapping_perm_rutschung AS (
    SELECT 
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
        'permanente_rutschung' AS teilprozess,
        ST_multi(geometrie) AS geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_kont_sackung
    WHERE 
        publiziert = true 
        AND 
        gef_stufe != 'keine'
)

,rutschungen_union AS (
    SELECT * FROM attribute_mapping_hangmure
    UNION ALL 
    SELECT * FROM attribute_mapping_plo_rutschung
    UNION ALL 
    SELECT * FROM attribute_mapping_perm_rutschung
)

,rutschung_prio AS (
    SELECT 
        gefahrenstufe, 
        charakterisierung,
        teilprozess,
        geometrie,
        CASE
            WHEN gefahrenstufe = 'restgefaehrdung' 
            THEN 0
            WHEN gefahrenstufe = 'gering' 
            THEN 1 
            WHEN gefahrenstufe = 'mittel' 
            THEN 2 
            WHEN gefahrenstufe = 'erheblich' 
            THEN 3
        end AS prio 
    FROM 
        rutschungen_union
)
        
,rutschung_prio_clip AS (
    SELECT 
        a.gefahrenstufe, 
        a.charakterisierung, 
        teilprozess,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
    FROM  
        rutschung_prio AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            rutschung_prio AS b
        WHERE 
            a.geometrie && b.geometrie 
            AND 
            a.prio < b.prio              
    ) AS blade		
)

,rutschung_boundary AS (
  SELECT 
    ST_union(ST_boundary(geometrie)) AS geometrie
  FROM
    rutschung_prio_clip
)

,rutschung_split_poly AS (
  SELECT 
    (ST_dump(ST_polygonize(geometrie))).geom AS geometrie
  FROM
    rutschung_boundary
)

,rutschung_split_poly_points AS (
  SELECT 
    ROW_NUMBER() OVER() AS id,
    geometrie AS poly,
    ST_pointonsurface(geometrie) AS point
  FROM
    rutschung_split_poly
)
	
,rutschung_point_on_polygons AS (
    SELECT 
        s.id,
        p.gefahrenstufe,
        string_agg(p.charakterisierung,', ') AS charakterisierung,
        string_agg(p.teilprozess,', ') AS teilprozess
    FROM
        rutschung_split_poly_points s
    JOIN
        rutschung_prio_clip p ON ST_within(s.point, p.geometrie)
    GROUP BY 
        s.id,
        p.gefahrenstufe
),

rutschung_charakterisierung_agg AS (
    SELECT 
        polygone.gefahrenstufe,
        polygone.charakterisierung,
        polygone.teilprozess,
        point.poly AS geometrie
    FROM 
        rutschung_split_poly_points point 
    LEFT JOIN 
        rutschung_point_on_polygons polygone 
        ON 
        polygone.id = point.id
)

,basket AS (
     SELECT 
         t_id 
     FROM 
         afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung (
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
    basket.t_id AS t_basket,
    'rutschung' AS hauptprozess, 
    gefahrenstufe,
    charakterisierung,
    teilprozess,
    geometrie,
    'Altdaten' AS datenherkunft, 
    null AS auftrag_neudaten   
FROM 
    rutschung_charakterisierung_agg,
    basket
WHERE 
    gefahrenstufe is not null --Kommt vor wegen neu polygonierung 
    AND 
    charakterisierung is not null 
;
