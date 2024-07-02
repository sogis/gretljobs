DELETE FROM afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser
;

WITH 
basket AS (
     SELECT 
         t_id,
         attachmentkey
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
) 

,hauptprozess_wasser AS ( 
    SELECT
        gefahrenstufe, 
        charakterisierung, 
        (st_dump(geometrie)).geom AS geometrie	
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_murgang 
    WHERE 
        datenherkunft = 'Neudaten'
    UNION ALL 
    SELECT 
        gefahrenstufe,
        charakterisierung, 
        (ST_Dump(geometrie)).geom AS geometrie
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_ueberflutung
    WHERE 
        datenherkunft = 'Neudaten'
)

,hauptprozess_wasser_clean AS (
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
        geometrie 
    FROM 
        hauptprozess_wasser 
    WHERE 
        ST_area(geometrie) > 0.01
)

,hauptprozess_wasser_clean_prio AS (
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
        geometrie,
        CASE 
            WHEN gefahrenstufe = 'restgefaehrdung' THEN 0 
            WHEN gefahrenstufe = 'gering' THEN 1 
            WHEN gefahrenstufe = 'mittel' THEN 2 
            WHEN gefahrenstufe = 'erheblich' THEN 3
        END AS prio 
    FROM 
        hauptprozess_wasser_clean
)

,hauptprozess_wasser_clean_prio_clip AS (
    SELECT 
        a.gefahrenstufe, 
        a.charakterisierung, 
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
    FROM  
        hauptprozess_wasser_clean_prio AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            hauptprozess_wasser_clean_prio AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio < b.prio              
    ) AS blade		
)

,hauptprozess_wasser_boundary AS (
    SELECT 
        ST_union(st_boundary(geometrie)) AS geometrie
    FROM
        hauptprozess_wasser_clean_prio_clip
)

,hauptprozess_wasser_split_poly AS (
    SELECT 
        (ST_dump(ST_polygonize(geometrie))).geom AS geometrie
    FROM
        hauptprozess_wasser_boundary
)

,hauptprozess_wasser_split_poly_points AS (
    SELECT 
        ROW_NUMBER() OVER() AS id,
        geometrie AS poly,
        ST_pointonsurface(geometrie) AS point
    FROM
        hauptprozess_wasser_split_poly
)
	
,hauptprozess_wasser_point_on_polygons AS (
    SELECT 
        s.id,
        p.gefahrenstufe,
        string_agg(p.charakterisierung,', ') AS charakterisierung
    FROM
        hauptprozess_wasser_split_poly_points s
    JOIN
        hauptprozess_wasser_clean_prio_clip p ON st_within(s.point, p.geometrie)
    GROUP BY 
        s.id,
        p.gefahrenstufe
)

,hauptprozess_wasser_charakterisierung_agg AS (
    SELECT 
        polygone.gefahrenstufe,
        polygone.charakterisierung,
        point.poly AS geometrie
    FROM 
        hauptprozess_wasser_split_poly_points point 
    LEFT JOIN 
        hauptprozess_wasser_point_on_polygons polygone 
        ON 
        polygone.id = point.id
)

-- Flächen mit gleicher Gefahrenstufe und gleicher Charakterisierung können zusammengefasst werden
,hauptprozess_wasser_union AS (
    SELECT 
        gefahrenstufe,
        charakterisierung,
        ST_union(geometrie) AS geometrie
    FROM 
        hauptprozess_wasser_charakterisierung_agg
    GROUP BY 
        gefahrenstufe,
        charakterisierung 
)

,hauptprozess_wasser_dump AS (
    SELECT 
        gefahrenstufe,
        charakterisierung,
        (ST_dump(geometrie)).geom AS geometrie
    FROM 
        hauptprozess_wasser_union
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
    'wasser' AS hauptprozess,
    gefahrenstufe,
    charakterisierung,
    st_multi(geometrie) AS geometrie, 
    'Neudaten' AS datenherkunft, 
    basket.attachmentkey AS auftrag_neudaten   
from 
    basket,
    hauptprozess_wasser_dump
WHERE 
    ST_area(geometrie) > 0.01 
    and 
    charakterisierung is not null 
;