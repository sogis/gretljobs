with
attribute_mapping_hangmure as (
    SELECT 
        case 
        	when gef_stufe = 'vorhanden' then 'restgefaehrdung'
        	when gef_stufe = 'gering' then 'gering'
        	when gef_stufe = 'mittel' then 'mittel' 
        	when gef_stufe = 'erheblich' then 'erheblich'
        end as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_hangmure
    where 
        publiziert = true 
        and 
        gef_stufe != 'keine'
), 

attribute_mapping_plo_rutschung as (
    SELECT 
        case 
        	when gef_stufe = 'vorhanden' then 'restgefaehrdung'
        	when gef_stufe = 'gering' then 'gering'
        	when gef_stufe = 'mittel' then 'mittel' 
        	when gef_stufe = 'erheblich' then 'erheblich'
        end as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_spontan
    where 
        publiziert = true 
        and 
        gef_stufe != 'keine'
),

attribute_mapping_perm_rutschung as (
    SELECT 
        case 
        	when gef_stufe = 'vorhanden' then 'restgefaehrdung'
        	when gef_stufe = 'gering' then 'gering'
        	when gef_stufe = 'mittel' then 'mittel' 
        	when gef_stufe = 'erheblich' then 'erheblich'
        end as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_kont_sackung
    where 
        publiziert = true 
        and 
        gef_stufe != 'keine'
)

,rutschungen_union as (
    select * from attribute_mapping_hangmure
    union all 
    select * from attribute_mapping_plo_rutschung
    union all 
    select * from attribute_mapping_perm_rutschung
)

,rutschung_prio as (
    select 
        gefahrenstufe, 
        charakterisierung,
        geometrie,
        case
        	when gefahrenstufe = 'restgefaehrdung' then 0
        	when gefahrenstufe = 'gering' then 1 
        	when gefahrenstufe = 'mittel' then 2 
        	when gefahrenstufe = 'erheblich' then 3
        end as prio 
    from 
        rutschungen_union
)
        
,rutschung_prio_clip as (
    SELECT 
	    a.gefahrenstufe, 
		a.charakterisierung, 
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
            and 
            a.prio < b.prio              
    ) AS blade		
)

,rutschung_boundary as (
  select 
    st_union(st_boundary(geometrie)) as geometrie
  from
    rutschung_prio_clip
)

,rutschung_split_poly AS (
  SELECT 
    (st_dump(st_polygonize(geometrie))).geom AS geometrie
  FROM
    rutschung_boundary
)

,rutschung_split_poly_points AS (
  SELECT 
    ROW_NUMBER() OVER() AS id,
    geometrie AS poly,
    st_pointonsurface(geometrie) AS point
  FROM
    rutschung_split_poly
)
	
,rutschung_point_on_polygons as (
    SELECT 
        s.id,
        p.gefahrenstufe,
        string_agg(p.charakterisierung,', ') AS charakterisierung
    FROM
        rutschung_split_poly_points s
    JOIN
        rutschung_prio_clip p ON st_within(s.point, p.geometrie)
    GROUP BY 
        s.id,
        p.gefahrenstufe
),

rutschung_charakterisierung_agg as (
    select 
        polygone.gefahrenstufe,
        polygone.charakterisierung,
	    point.poly as geometrie
    FROM 
	    rutschung_split_poly_points point 
    LEFT JOIN 
	    rutschung_point_on_polygons polygone 
        ON 
	    polygone.id = point.id
)

,basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung (
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
    'rutschung' as hauptprozess, 
    gefahrenstufe,
    charakterisierung,
    geometrie,
    'Altdaten' as datenherkunft, 
    null as auftrag_neudaten
    
from 
    rutschung_charakterisierung_agg,
    basket
where 
    gefahrenstufe is not null --Kommt vor wegen neu polygonierung 
    and 
    charakterisierung is not null 






