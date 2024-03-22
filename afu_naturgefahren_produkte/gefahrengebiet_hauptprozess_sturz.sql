delete from afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz
;

with 
basket as (
     select 
         t_id,
         attachmentkey
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
), 

hauptprozess_sturz as ( 
    SELECT
        gefahrenstufe, 
	    charakterisierung, 
	    (st_dump(geometrie)).geom as geometrie	
	FROM 
	    afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_stein_blockschlag  
    where 
	    datenherkunft = 'Neudaten'
	union all 
	SELECT
        gefahrenstufe, 
	    charakterisierung, 
	    (st_dump(geometrie)).geom as geometrie	
	FROM 
	    afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_fels_bergsturz 
    where 
	    datenherkunft = 'Neudaten'
),

hauptprozess_sturz_clean as (
    SELECT 
	    gefahrenstufe, 
		charakterisierung, 
		geometrie 
	FROM 
	    hauptprozess_sturz 
	WHERE 
        st_area(geometrie) > 0.001
),

-- Die Priorisierung wird hier gleich von der Charakterisierung übernommen. Alle Sturz-Prozesse weisen die Charakterisierung SX auf und gemäss
-- Prozessmatrix ist die Zahl auch gleichbedeutend mit "Höherrangig". Es gibt keine geteilten Kästchen.  
-- Das heisst: Bei einer allfälligen Überlagerung werden die Charakterisierungen eh nicht aggregiert, sondern die Charakterisierung 
-- mit dem höchsten Wert gewinnt. Deshalb reicht ein einfaches Clip aus.  

hauptprozess_sturz_clean_prio as (
    SELECT 
	    gefahrenstufe, 
		charakterisierung, 
		geometrie,
		substring(charakterisierung from 2 for 1) as prio  
	FROM 
        hauptprozess_sturz_clean
),

hauptprozess_sturz_clean_prio_clip as (
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
            and 
            a.prio < b.prio              
    ) AS blade		
),
	
-- Flächen mit gleicher Gefahrenstufe und gleicher Charakterisierung können zusammengefasst werden
hauptprozess_sturz_union as (
    select 
        gefahrenstufe,
        charakterisierung,
        st_union(geometrie) as geometrie
    from 
        hauptprozess_sturz_clean_prio_clip
    group by 
        gefahrenstufe,
        charakterisierung 
)

,hauptprozess_sturz_dump as (
    select 
        gefahrenstufe,
        charakterisierung,
        (st_dump(geometrie)).geom as geometrie
    from 
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

select 
    basket.t_id as t_basket,
    'sturz' as hauptprozess,
    gefahrenstufe,
    charakterisierung,
    st_multi(geometrie) as geometrie,
    'Neudaten' as datenherkunft, 
    basket.attachmentkey as auftrag_neudaten   
from 
    basket,
    hauptprozess_sturz_dump
WHERE 
    st_area(geometrie) > 0.001 
    and 
    charakterisierung is not null 



