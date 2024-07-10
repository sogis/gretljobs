WITH
hauptprozesse_clean as (
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
        geometrie 
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser 
    UNION ALL 
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
        geometrie  
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung 
    UNION ALL 
    SELECT 
        gefahrenstufe, 
        charakterisierung, 
	geometrie 
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz 
    UNION ALL 
    SELECT 
        gefahrenstufe,
        charakterisierung, 
        geometrie
    FROM 
        afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_absenkung_einsturz   
)

,hauptprozesse_clean_prio as (
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
    WHERE 
        ST_Isempty(geometrie) is not true
)

INSERT INTO gk_poly (
    prio, 
    gefahrenstufe, 
    charakterisierung, 
    geometrie
) 
SELECT
    prio,
    gefahrenstufe,
    charakterisierung,
    (ST_Dump(geometrie)).geom as geometrie 
FROM 
    hauptprozesse_clean_prio
;