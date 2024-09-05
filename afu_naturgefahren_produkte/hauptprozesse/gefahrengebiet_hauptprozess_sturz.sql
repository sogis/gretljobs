WITH 
basket AS (
     SELECT 
         t_id,
         attachmentkey
     FROM 
         afu_naturgefahren_staging_v1.t_ili2db_basket
), 

hauptprozess_sturz AS ( 
    SELECT
        gefahrenstufe, 
        charakterisierung, 
        (ST_dump(geometrie)).geom AS geometrie	
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_stein_blockschlag  
    WHERE 
        datenherkunft = 'Neudaten'
    UNION ALL 
    SELECT
        gefahrenstufe, 
        charakterisierung, 
        (ST_dump(geometrie)).geom AS geometrie	
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_fels_bergsturz 
    WHERE 
        datenherkunft = 'Neudaten'
)

,hauptprozess_sturz_clean AS (
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
        geometrie 
    FROM 
        hauptprozess_sturz 
    WHERE 
        ST_area(geometrie) > 0.001
)

-- Die Priorisierung wird hier gleich von der Charakterisierung übernommen. Alle Sturz-Prozesse weisen die Charakterisierung SX auf und gemäss
-- Prozessmatrix ist die Zahl auch gleichbedeutend mit "Höherrangig". Es gibt keine geteilten Kästchen.  
-- Das heisst: Bei einer allfälligen Überlagerung werden die Charakterisierungen eh nicht aggregiert, sondern die Charakterisierung 
-- mit dem höchsten Wert gewinnt. Deshalb reicht ein einfaches Clip aus.  

,hauptprozess_sturz_clean_prio AS (
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
        geometrie,
        CASE 
            WHEN charakterisierung = 'S10' THEN 0::integer
            ELSE substring(charakterisierung FROM 2 for 1)::integer 
    END AS prio  
    FROM 
        hauptprozess_sturz_clean
)

,hauptprozess_sturz_clean_prio_clip AS (
    SELECT 
        a.gefahrenstufe, 
        a.charakterisierung, 
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
    FROM  
        hauptprozess_sturz_clean_prio AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            hauptprozess_sturz_clean_prio AS b
        WHERE 
            a.geometrie && b.geometrie 
            AND 
            a.prio < b.prio              
    ) AS blade		
)
	
-- Flächen mit gleicher Gefahrenstufe und gleicher Charakterisierung können zusammengefasst werden
,hauptprozess_sturz_union AS (
    SELECT 
        gefahrenstufe,
        charakterisierung,
        st_union(geometrie) AS geometrie
    FROM 
        hauptprozess_sturz_clean_prio_clip
    GROUP BY 
        gefahrenstufe,
        charakterisierung 
)

,hauptprozess_sturz_dump AS (
    SELECT 
        gefahrenstufe,
        charakterisierung,
        (st_dump(geometrie)).geom AS geometrie
    FROM 
        hauptprozess_sturz_union
)


INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz (
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
    'sturz' AS hauptprozess,
    gefahrenstufe,
    charakterisierung,
    st_multi(geometrie) AS geometrie,
    'Neudaten' AS datenherkunft, 
    basket.attachmentkey AS auftrag_neudaten   
FROM 
    basket,
    hauptprozess_sturz_dump
WHERE 
    ST_area(geometrie) > 0.001 
    and 
    charakterisierung is not null 



