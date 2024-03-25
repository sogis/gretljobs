
with 
hauptprozesse_clean as (
    SELECT 
	    gefahrenstufe, 
        charakterisierung, 
	    geometrie 
    FROM 
	    afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser 
-- DIE ALTEN UFEREROSIONEN SIND JETZT DOCH IN DER GK HAUPTPROZESS WASSER                      
--    union all
--    select  --UFEREROSION aus Altdaten
--        case 
--    	    when gef_stufe = 'vorhanden' then 'restgefaehrdung'
--            when gef_stufe = 'gering' then 'gering'
--            when gef_stufe = 'mittel' then 'mittel' 
--            when gef_stufe = 'erheblich' then 'erheblich'
--        end as gefahrenstufe, 
--		replace(aindex, '_', '') as charakterisierung, 
--		geometrie
--	from 
--	    afu_gefahrenkartierung.gefahrenkartirung_gk_wasser
--	where 
--	    publiziert is true
--        and 
--        gef_stufe != 'keine'
--        and 
--        prozessa = 'Ufererosion'
-- DIE NEUEN UFEREROSIONEN SOLLEN IN DER Syn. GK NICHT BERÜCKSICHTIGT WERDEN
--    union all 
--    select --Neue Ufererosionen
--        'erheblich' as gefahrenstufe, 
--        'Ufererosion' as charakterisierung, 
--        geometrie 
--    from 
--        afu_naturgefahren_staging_v1.ufererosion
--    where 
--        datenherkunft = 'Neudaten'
    union all 
    SELECT 
	    gefahrenstufe, 
        charakterisierung, 
	    geometrie  
    FROM 
	    afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung 
    union all 
    SELECT 
	    gefahrenstufe, 
        charakterisierung, 
	    geometrie 
    FROM 
	afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz 
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
)

INSERT INTO gk_poly (
    prio, 
    gefahrenstufe, 
    charakterisierung, 
    geometrie
) 
select 
    prio,
    gefahrenstufe,
    charakterisierung,
    (st_dump(geometrie)).geom as geometrie 
from 
    hauptprozesse_clean_prio
