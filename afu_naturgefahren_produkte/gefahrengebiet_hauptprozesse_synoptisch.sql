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
	    geometrie 
    FROM 
	    afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser 
    WHERE 
        st_area(geometrie) > 0.001                      
    union all
    SELECT 
	    gefahrenstufe, 
        charakterisierung, 
	    geometrie  
    FROM 
	    afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung 
    WHERE 
        st_area(geometrie) > 0.001
    union all 
    SELECT 
	    gefahrenstufe, 
        charakterisierung, 
	    geometrie 
    FROM 
	afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz 
    WHERE 
        st_area(geometrie) > 0.001
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

hauptprozesse_boundary as (
    select 
        st_union(st_boundary(geometrie)) as geometrie
    from
        hauptprozesse_clip_clean
),

hauptprozesse_split_poly AS (
  SELECT 
    (st_dump(st_polygonize(geometrie))).geom AS geometrie
  FROM
    hauptprozesse_boundary
),

hauptprozesse_split_poly_points AS (
  SELECT 
    ROW_NUMBER() OVER() AS id,
    geometrie AS poly,
    st_pointonsurface(geometrie) AS point
  FROM
    hauptprozesse_split_poly
),
	
hauptprozesse_point_on_polygons as (
    SELECT 
        s.id,
        p.gefahrenstufe,
        string_agg(p.charakterisierung,', ') AS charakterisierung
    FROM
        hauptprozesse_split_poly_points s
    JOIN
        hauptprozesse_clip_clean p ON st_within(s.point, p.geometrie)
    GROUP BY 
        s.id,
        p.gefahrenstufe
),

hauptprozesse_charakterisierung_agg as (
    select 
        polygone.gefahrenstufe,
        polygone.charakterisierung,
	    point.poly as geometrie
    FROM 
	    hauptprozesse_split_poly_points point 
    LEFT JOIN 
	    hauptprozesse_point_on_polygons polygone 
        ON 
	    polygone.id = point.id
),

-- Flächen mit gleicher Gefahrenstufe und gleicher Charakterisierung können zusammengefasst werden
hauptprozesse_union as (
    select 
        gefahrenstufe,
        charakterisierung,
        st_union(geometrie) as geometrie
    from 
        hauptprozesse_charakterisierung_agg
    group by 
        gefahrenstufe,
        charakterisierung 
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
	    hauptprozesse_union 
	where 
	    charakterisierung is not null 
)

--Polygone die unzusammenhängend sinnd müssen wieder aufgetrennt werden. 
--hauptprozesse_polygon_dump as (
--    select
--        gefahrenstufe, 
--        charakterisierung,
--        (st_dump(geometrie)).geom as geometrie
--    from 
--        hauptprozesse_charakterisierung_sort
--)

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





