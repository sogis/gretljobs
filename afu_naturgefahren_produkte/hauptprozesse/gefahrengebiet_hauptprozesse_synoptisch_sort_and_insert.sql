WITH
splitted_attributes_mapping AS (
    select 
        case 
            when gef_max = 0 then 'nicht_gefaehrdet'
            when gef_max = 1 then 'restgefaehrdung'
            when gef_max = 2 then 'gering' 
            when gef_max = 3 then 'mittel' 
            when gef_max = 4 then 'erheblich' 
        end as gefahrenstufe,
        charakterisierung, 
        poly AS geometrie 
    FROM 
        splited        
)
    
-- Die Charakterisierungen müssen sortiert werden
,hauptprozesse_charakterisierung_sort AS (
    SELECT 
        gefahrenstufe,
        array_to_string(
            array(
                select distinct 
                    unnest(
                        string_to_array(charakterisierung,', ')
                    ) AS x 
                ORDER BY x
            ),', '
       ) AS charakterisierung,
	   geometrie
	FROM 
	    splitted_attributes_mapping
)

--Polygone die unzusammenhängend sinnd müssen wieder aufgetrennt werden. 
,hauptprozesse_polygon_dump as (
    SELECT
        gefahrenstufe, 
        charakterisierung,
        (ST_Dump(geometrie)).geom AS geometrie
    FROM 
        hauptprozesse_charakterisierung_sort
)

,basket as (
     SELECT 
         t_id 
     FROM 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 )

INSERT INTO afu_naturgefahren_staging_v1.synoptisches_gefahrengebiet (
    t_basket, 
    gefahrenstufe, 
    charakterisierung, 
    geometrie
) 
SELECT 
    basket.t_id AS t_basket,
    gefahrenstufe,
    charakterisierung,
    ST_Multi(geometrie) AS geometrie 
FROM 
    basket,
    hauptprozesse_polygon_dump
WHERE 
    ST_Area(geometrie) > 0.001 
    AND 
    charakterisierung is not null 
;