delete from afu_naturgefahren_staging_v1.synoptisches_gefahrengebiet
;

with 
 basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 ), 

hauptprozesse_clean as (
    SELECT 
	gefahrenstufe, 
        charakterisierung, 
	st_reduceprecision(geometrie,0.001) as geometrie 
    FROM 
	afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser 
    WHERE 
        st_area(geometrie) > 0.001
--        and 
--        datenherkunft = 'Neudaten'

    union all 

    SELECT 
	gefahrenstufe, 
        charakterisierung, 
	st_reduceprecision(geometrie,0.001) as geometrie  
    FROM 
	afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung 
    WHERE 
        st_area(geometrie) > 0.001
--        and 
--        datenherkunft = 'Neudaten'

    union all 

    SELECT 
	gefahrenstufe, 
        charakterisierung, 
	st_reduceprecision(geometrie,0.001) as geometrie 
    FROM 
	afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz 
    WHERE 
        st_area(geometrie) > 0.001
--        and 
--        datenherkunft = 'Neudaten'
),

hauptprozesse_clean_prio as (
    SELECT 
        gefahrenstufe, 
	    charakterisierung, 
	    geometrie,
	    CASE 
		    when gefahrenstufe = 'nicht_gefaehrdet' then 0
	        WHEN gefahrenstufe = 'restgefaehrdung' THEN 1 
	        WHEN gefahrenstufe = 'gering' THEN 2 
	        WHEN gefahrenstufe = 'mittel' THEN 3 
	        WHEN gefahrenstufe = 'erheblich' THEN 4
	END as prio 
    FROM 
        hauptprozesse_clean
    where 
        st_isempty(geometrie) is not true
),

hauptprozesse_clean_prio_clip as (
    SELECT 
	    a.gefahrenstufe, 
		a.charakterisierung, 
		ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
    FROM  
        hauptprozesse_clean_prio AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            hauptprozesse_clean_prio AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio < b.prio              
    ) AS blade		
),

hauptprozesse_clip_clean as (
    select 
        gefahrenstufe, 
        charakterisierung,
        st_reducePrecision(geometrie,0.001) as geometrie
    from 
        hauptprozesse_clean_prio_clip
),

hauptprozesse_point_on_polygons as (
    select 
	    gefahrenstufe,
		string_to_array(charakterisierung,' ') as charakterisierung, 
		st_pointOnSurface((st_dump(geometrie)).geom) as punkt_geometrie 
	FROM 
	    hauptprozesse_clip_clean
	where 
	    st_isempty(geometrie) is not true 
),

hauptprozesse_geometrie_union as (
    select 
        gefahrenstufe, 
        st_union(geometrie) as geometrie 
    from 
        hauptprozesse_clip_clean
    where 
	    st_isempty(geometrie) is not true 
    GROUP by 
        gefahrenstufe
),

hauptprozesse_geometrie_split as (
    select 
        gefahrenstufe, 
        (st_dump(geometrie)).geom as geometrie 
    from 
        hauptprozesse_geometrie_union
),

hauptprozesse_charakterisierung_agg as (
    select 
        polygone.gefahrenstufe,
        string_agg(array_to_string(point.charakterisierung,', '),', ') as charakterisierung,
	    polygone.geometrie
	FROM 
	    hauptprozesse_geometrie_split polygone 
    LEFT JOIN 
	    hauptprozesse_point_on_polygons point 
		ON 
		ST_Dwithin(point.punkt_geometrie, polygone.geometrie,0)
    where 
        st_area(polygone.geometrie) > 0.001
	group by 
	    polygone.geometrie, 
	    polygone.gefahrenstufe
),

hauptprozesse_charakterisierung_sort as (
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
	    hauptprozesse_charakterisierung_agg 
	where 
	    charakterisierung is not null 
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
    hauptprozesse_charakterisierung_sort
WHERE 
    st_area(geometrie) > 0.001 
    and 
    charakterisierung is not null 
;



