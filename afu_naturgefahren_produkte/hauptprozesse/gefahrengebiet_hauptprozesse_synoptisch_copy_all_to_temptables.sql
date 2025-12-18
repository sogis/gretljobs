WITH
hauptprozesse_clean as (
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
        geometrie, 
        'Wasser' as hauptprozess
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser 
    UNION ALL 
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
        geometrie, 
        'Rutschung' as hauptprozess 
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung 
    UNION ALL 
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
	geometrie, 
        'Sturz' as hauptprozess
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz   
)

,hauptprozesse_clean_prio as (
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
        geometrie,
        hauptprozess,
            CASE 
                when gefahrenstufe = 'nicht_gefaehrdet' then 0
                WHEN gefahrenstufe = 'restgefaehrdung' THEN 1 
                WHEN gefahrenstufe = 'gering' THEN 2 
                WHEN gefahrenstufe = 'mittel' THEN 3 
                WHEN gefahrenstufe = 'erheblich' THEN 4
        END as prio 
    FROM 
        hauptprozesse_clean
    WHERE 
        ST_Isempty(geometrie) is not true
)

INSERT INTO gk_poly (
    prio, 
    gefahrenstufe, 
    charakterisierung,
    hauptprozess, 
    geometrie
) 
SELECT
    prio,
    gefahrenstufe,
    charakterisierung,
    hauptprozess,
    (ST_Dump(geometrie)).geom as geometrie 
FROM 
    hauptprozesse_clean_prio
;