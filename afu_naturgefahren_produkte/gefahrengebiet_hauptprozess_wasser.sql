delete from afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser
;

with 
orig_dataset as (
    select
        t_id  as dataset  
    from 
        afu_naturgefahren_v1.t_ili2db_dataset
    where 
        datasetname = ${kennung}
),

orig_basket as (
    select 
        basket.attachmentkey,
        basket.t_id 
    from 
        afu_naturgefahren_v1.t_ili2db_basket basket,
        orig_dataset
    where 
        basket.dataset = orig_dataset.dataset
        and 
        topic like '%Befunde'
),

basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
), 

hauptprozess_wasser as ( 
    SELECT
        gefahrenstufe, 
	    charakterisierung, 
	    (st_dump(geometrie)).geom as geometrie	
	FROM 
	    afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_murgang 
	where 
	    datenherkunft = 'Neudaten'
    union all 
    select 
	    gefahrenstufe,
	    charakterisierung, 
	    (ST_Dump(geometrie)).geom as geometrie
	from 
	    afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_ueberflutung
	where 
	    datenherkunft = 'Neudaten'
),

hauptprozess_wasser_clean as (
    SELECT 
	    gefahrenstufe, 
		charakterisierung, 
		geometrie 
	FROM 
	    hauptprozess_wasser 
	WHERE 
        st_area(geometrie) > 0.01
),

hauptprozess_wasser_clean_prio as (
    SELECT 
	    gefahrenstufe, 
		charakterisierung, 
		geometrie,
		CASE 
		    WHEN gefahrenstufe = 'restgefaehrdung' THEN 0 
		    WHEN gefahrenstufe = 'gering' THEN 1 
		    WHEN gefahrenstufe = 'mittel' THEN 2 
		    WHEN gefahrenstufe = 'erheblich' THEN 3
		END as prio 
	FROM 
        hauptprozess_wasser_clean
),

hauptprozess_wasser_clean_prio_clip as (
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
),

hauptprozess_wasser_boundary as (
  select 
    st_union(st_boundary(geometrie)) as geometrie
  from
    hauptprozess_wasser_clean_prio_clip
),

hauptprozess_wasser_split_poly AS (
  SELECT 
    (st_dump(st_polygonize(geometrie))).geom AS geometrie
  FROM
    hauptprozess_wasser_boundary
),

hauptprozess_wasser_split_poly_points AS (
  SELECT 
    ROW_NUMBER() OVER() AS id,
    geometrie AS poly,
    st_pointonsurface(geometrie) AS point
  FROM
    hauptprozess_wasser_split_poly
),
	
hauptprozess_wasser_point_on_polygons as (
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
),

hauptprozess_wasser_charakterisierung_agg as (
    select 
        polygone.gefahrenstufe,
        polygone.charakterisierung,
	    point.poly as geometrie
    FROM 
	    hauptprozess_wasser_split_poly_points point 
    LEFT JOIN 
	    hauptprozess_wasser_point_on_polygons polygone 
        ON 
	    polygone.id = point.id
),

-- Flächen mit gleicher Gefahrenstufe und gleicher Charakterisierung können zusammengefasst werden
hauptprozess_wasser_union as (
    select 
        gefahrenstufe,
        charakterisierung,
        st_union(geometrie) as geometrie
    from 
        hauptprozess_wasser_charakterisierung_agg
    group by 
        gefahrenstufe,
        charakterisierung 
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

select 
    basket.t_id as t_basket,
    'wasser' as hauptprozess,
    gefahrenstufe,
    charakterisierung,
    st_multi(geometrie) as geometrie, 
    'Neudaten' as datenherkunft, 
    orig_basket.attachmentkey as auftrag_neudaten   
from 
    basket,
    orig_basket,
    hauptprozess_wasser_union
WHERE 
    st_area(geometrie) > 0.01 
    and 
    charakterisierung is not null 
;


