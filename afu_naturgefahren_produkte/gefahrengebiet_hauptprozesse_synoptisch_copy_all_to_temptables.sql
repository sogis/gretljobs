
with 
hauptprozesse_clean as (
    SELECT 
	    gefahrenstufe, 
        charakterisierung, 
	    geometrie 
    FROM 
	    afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser                       
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