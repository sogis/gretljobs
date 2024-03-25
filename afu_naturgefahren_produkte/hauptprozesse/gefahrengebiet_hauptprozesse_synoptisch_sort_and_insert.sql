delete from afu_naturgefahren_staging_v1.synoptisches_gefahrengebiet
;

with 
splitted_attributes_mapping as (
    select 
        case 
        	when gef_max = 0 then 'nicht_gefaehrdet'
        	when gef_max = 1 then 'restgefaehrdung'
        	when gef_max = 2 then 'gering' 
        	when gef_max = 3 then 'mittel' 
        	when gef_max = 4 then 'erheblich' 
        end as gefahrenstufe,
        charakterisierung, 
        poly as geometrie 
    from 
        splited        
)
    
-- Die Charakterisierungen müssen sortiert werden
,hauptprozesse_charakterisierung_sort as (
    select 
       gefahrenstufe,
       array_to_string(
           array(
               select distinct 
                   unnest(
                       string_to_array(charakterisierung,', ')
                   ) as x 
               order by x
           ),', '
       ) as charakterisierung,
	   geometrie
	FROM 
	    splitted_attributes_mapping
)

--Polygone die unzusammenhängend sinnd müssen wieder aufgetrennt werden. 
,hauptprozesse_polygon_dump as (
    select
        gefahrenstufe, 
        charakterisierung,
        (st_dump(geometrie)).geom as geometrie
    from 
        hauptprozesse_charakterisierung_sort
)

,basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 )

INSERT INTO afu_naturgefahren_staging_v1.synoptisches_gefahrengebiet (
    t_basket, 
    gefahrenstufe, 
    charakterisierung, 
    geometrie
) 
select 
    basket.t_id as t_basket,
    gefahrenstufe,
    charakterisierung,
    st_multi(geometrie) as geometrie 
from 
    basket,
    hauptprozesse_polygon_dump
WHERE 
    st_area(geometrie) > 0.001 
    and 
    charakterisierung is not null 
;