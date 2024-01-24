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
    select 
        'wasser' as hauptprozess,
        'murgang' as teilprozess,
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 'restgefaehrdung' 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 'gering' 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 'mittel' 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 'erheblich'
        end as gefahrenstufe,
        case when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '30' then 6
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '100' then 5
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '300' then 4
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '30' then 9
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '100' then 8
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '300' then 7
             when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 0 --Restgefährdung hat immer die niedrigste Prio
        end as charakterisierung,
        geometrie, 
        'Neudaten' as datenherkunft,
        basket.attachmentkey as auftrag_neudaten
    from 
        afu_naturgefahren_v1.befunduebermurung befund
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
    where 
        befund.t_basket in (select t_id from orig_basket)
        
    union all 
    
    select 
        'wasser' as hauptprozess,
        'ueberschwemmung_statisch' as teilprozess,
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 'restgefaehrdung' 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 'gering' 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 'mittel' 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 'erheblich'
        end as gefahrenstufe,
        case when 
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '30' then 3
             when
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '100' then 2
             when
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '300' then 1
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '30' then 6
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '100' then 5
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '300' then 4
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '30' then 9
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '100' then 8
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '300' then 7  
             when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 0 --Restgefährdung hast immer die niedrigste Prio              
        end as charakterisierung,
        geometrie, 
        'Neudaten' as datenherkunft,
        basket.attachmentkey as auftrag_neudaten
    from 
        afu_naturgefahren_v1.befundueberschwemmungstatisch befund
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
    where 
        befund.t_basket in (select t_id from orig_basket)
        
    union all 
    
    select 
        'wasser' as hauptprozess,
        'ueberschwemmung_dynamisch' as teilprozess,
        case when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 'restgefaehrdung' 
             when
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 'gering' 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 'mittel' 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 'erheblich'
        end as gefahrenstufe,
        case when 
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '30' then 3
             when
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '100' then 2
             when
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '300' then 1
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '30' then 6
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '100' then 5
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '300' then 4
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '30' then 9
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '100' then 8
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '300' then 7  
             when 
             (string_to_array(iwcode, '_'))[1] = 'restgefaehrdung' then 0 --Restgefährdung hast immer die niedrigste Prio              
        end as charakterisierung,
        geometrie, 
        'Neudaten' as datenherkunft,
        basket.attachmentkey as auftrag_neudaten
    from 
        afu_naturgefahren_v1.befundueberschwemmungdynamisch befund
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
    where 
        befund.t_basket in (select t_id from orig_basket)      
),

hauptprozess_wasser_prio as (
    SELECT 
        a.hauptprozess,
        a.gefahrenstufe,
        case 
	        when a.gefahrenstufe = 'restgefaehrdung' then 'EHQ'
        	when (a.gefahrenstufe != 'restgefaehrdung' and teilprozess = 'murgang') then 'M'||a.charakterisierung
        	when (a.gefahrenstufe != 'restgefaehrdung' and teilprozess = 'ueberschwemmung_statisch') then 'U'||a.charakterisierung
        	when (a.gefahrenstufe != 'restgefaehrdung' and teilprozess = 'ueberschwemmung_dynamisch') then 'U'||a.charakterisierung
        end as charakterisierung,
        COALESCE(
            ST_Difference(st_makevalid(a.geometrie), st_makevalid(blade.geometrie)),
            a.geometrie
        ) AS geometrie, 
        a.datenherkunft,
        a.auftrag_neudaten
    FROM  
        hauptprozess_wasser AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            hauptprozess_wasser AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.charakterisierung < b.charakterisierung
    ) AS blade
), 

hauptprozess_wasser_geometry_cleaner as (
    select 
        hauptprozess, 
        gefahrenstufe,
        charakterisierung,
        (st_dump(geometrie)).geom as geometrie,
        datenherkunft,
        auftrag_neudaten 
    from 
        hauptprozess_wasser_prio
    where 
        st_isempty(geometrie) is not true
        and 
        st_area(geometrie) > 0.01
),

hauptprozess_wasser_polygone_exterior as (
    select
        gefahrenstufe,
        (st_DumpRings(geometrie)).geom as geometrie
    from
        hauptprozess_wasser_geometry_cleaner
    where
         st_isempty(geometrie) is not true  
         and 
         st_geometrytype(geometrie) = 'ST_Polygon'   
),

hauptprozess_wasser_boundary as (
    select 
        gefahrenstufe,
        st_union(geometrie) as geometrie
    from
        hauptprozess_wasser_polygone_exterior
    group by 
        gefahrenstufe
),

hauptprozess_wasser_split_poly AS (
  SELECT 
    (st_dump(st_polygonize(geometrie))).geom AS geometrie
  FROM
    hauptprozess_wasser_boundary
),

hauptprozess_wasser_split AS (
  SELECT 
    ROW_NUMBER() OVER() AS id,
    geometrie AS poly,
    st_pointonsurface(geometrie) AS point
  FROM
    hauptprozess_wasser_split_poly
)

SELECT 
    basket.t_id as t_basket,
    p.hauptprozess,
    p.gefahrenstufe,
    array_agg(distinct p.charakterisierung ORDER BY p.charakterisierung) AS charakterisierung,
    st_multi(poly) AS geometrie,
    p.datenherkunft,
    p.auftrag_neudaten
from
    basket,
    hauptprozess_wasser_split s
JOIN
    hauptprozess_wasser_geometry_cleaner p ON st_within(s.point, p.geometrie)
GROUP BY 
    s.id, p.hauptprozess, p.gefahrenstufe, p.datenherkunft, p.auftrag_neudaten, poly, basket.t_id
;




