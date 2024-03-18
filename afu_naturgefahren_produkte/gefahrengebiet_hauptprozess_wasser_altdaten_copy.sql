with
basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
),

hauptprozess_alt_wasser_prio as (
    SELECT 
	    'wasser' as hauptprozess, 
        case 
    	    when gef_stufe = 'vorhanden' then 'restgefaehrdung'
            when gef_stufe = 'gering' then 'gering'
            when gef_stufe = 'mittel' then 'mittel' 
            when gef_stufe = 'erheblich' then 'erheblich'
        end as gefahrenstufe, 
		replace(aindex, '_', '') as charakterisierung, 
		geometrie,
		CASE 
		    WHEN gef_stufe = 'vorhanden' then 0 
		    WHEN gef_stufe = 'gering' then 1 
		    WHEN gef_stufe = 'mittel' then 2 
		    WHEN gef_stufe = 'erheblich' then 3
		end || regexp_replace(aindex, '\D','','g') as prio --Die Prio setzt sich zusammen aus gef_stufe und Nummer der Charakterisierung. Grund: Geteilte Kästchen! 
	FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_wasser
    where 
        publiziert is true
        and 
        gef_stufe != 'keine'
),

hauptprozess_alt_wasser_prio_clip as (
    SELECT 
	    a.hauptprozess,
	    a.gefahrenstufe,
		a.charakterisierung, 
		ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
    FROM  
        hauptprozess_alt_wasser_prio AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            hauptprozess_alt_wasser_prio AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio < b.prio              
    ) AS blade		
),

hauptprozess_alt_wasser_union as (
    select 
        hauptprozess,
        gefahrenstufe,
        charakterisierung,
        st_union(geometrie) as geometrie
    from 
        hauptprozess_alt_wasser_prio_clip
    group by 
        hauptprozess,
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

SELECT 
    basket.t_id as t_basket,
    hauptprozess,
    gefahrenstufe, 
    charakterisierung, 
    st_multi(geometrie) as geometrie, --Im neuen Modell sind Multi-Polygone
    'Altdaten' as datenherkunft, 
    null as auftrag_neudaten
FROM 
    hauptprozess_alt_wasser_union,
    basket
;




