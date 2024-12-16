WITH 
beurteilungsgebiet_sturz AS (
    SELECT 
        erhebungsstand, 
        geometrie
    FROM 
        afu_naturgefahren_beurteilungsgebiet_v2.erhebungsgebiet_stein_block_schlag
    UNION ALL 
    SELECT 
        erhebungsstand, 
        geometrie
    FROM 
        afu_naturgefahren_beurteilungsgebiet_v2.erhebungsgebiet_fels_berg_sturz
)

,beurteilungsgebiet_rutschung AS (
    SELECT 
        erhebungsstand, 
        geometrie
    FROM 
        afu_naturgefahren_beurteilungsgebiet_v2.erhebungsgebiet_permanente_rutschung
    UNION ALL 
    SELECT 
        erhebungsstand, 
        geometrie
    FROM 
        afu_naturgefahren_beurteilungsgebiet_v2.erhebungsgebiet_spontane_rutschung
    UNION ALL 
    SELECT 
        erhebungsstand, 
        geometrie
    FROM 
        afu_naturgefahren_beurteilungsgebiet_v2.erhebungsgebiet_hangmure
)

,beurteilungsgebiet_wasser AS (
    SELECT 
        erhebungsstand, 
        geometrie
    FROM 
        afu_naturgefahren_beurteilungsgebiet_v2.erhebungsgebiet_ueberschwemmung
    UNION ALL 
    SELECT 
        erhebungsstand, 
        geometrie
    FROM 
        afu_naturgefahren_beurteilungsgebiet_v2.erhebungsgebiet_uebermurung
)

,rockfall AS (
    SELECT 
        'rockfall' AS main_process,
        CASE
            WHEN gefahrenstufe = 'restgefaehrdung'
                THEN 'residual_hazard'
            WHEN gefahrenstufe = 'gering'
                THEN 'slight'
            WHEN gefahrenstufe = 'mittel'
                THEN 'mean'
            WHEN gefahrenstufe = 'erheblich'
                THEN 'substantial'
        END AS hazard_level,
        'complete' AS subprocesses_complete,    
        'complete' AS sources_complete, 
        (st_dump(geometrie)).geom AS impact_zone,
        CAST('SO' AS VARCHAR) AS data_responsibility,
        NULL AS comments
    FROM 
        afu_naturgefahren_staging_v2.gefahrengebiet_hauptprozess_sturz
--    UNION ALL 
--    SELECT
--        'rockfall' AS main_process,
--        'not_in_danger' AS hazard_level,
--        'complete' AS subprocesses_complete,    
--        'complete' AS sources_complete, 
--        st_difference(erhebungsgebiet.geometrie,hauptprozess.geometrie) AS impact_zone,
--        CAST('SO' AS VARCHAR) AS data_responsibility,
--        NULL AS comments
--    FROM 
--        beurteilungsgebiet_sturz erhebungsgebiet, 
--        (
--            SELECT 
--                st_union(geometrie) AS geometrie 
--            FROM 
--                afu_naturgefahren_staging_v2.gefahrengebiet_hauptprozess_sturz
--        ) hauptprozess
)

,landslide AS (
    SELECT 
        'landslide' AS main_process,
        CASE
            WHEN gefahrenstufe = 'restgefaehrdung'
                THEN 'residual_hazard'
            WHEN gefahrenstufe = 'gering'
                THEN 'slight'
            WHEN gefahrenstufe = 'mittel'
                THEN 'mean'
            WHEN gefahrenstufe = 'erheblich'
                THEN 'substantial'
        END AS hazard_level,
        'complete' AS subprocesses_complete,    
        'complete' AS sources_complete, 
        (st_dump(geometrie)).geom AS impact_zone,
        CAST('SO' AS VARCHAR) AS data_responsibility,
        NULL AS comments
    FROM 
        afu_naturgefahren_staging_v2.gefahrengebiet_hauptprozess_rutschung
--    UNION ALL 
--    SELECT
--        'landslide' AS main_process,
--        'not_in_danger' AS hazard_level,
--        'complete' AS subprocesses_complete,    
--        'complete' AS sources_complete, 
--        st_difference(erhebungsgebiet.geometrie,hauptprozess.geometrie) AS impact_zone,
--        CAST('SO' AS VARCHAR) AS data_responsibility,
--        NULL AS comments
--    FROM 
--        beurteilungsgebiet_rutschung erhebungsgebiet, 
--        (
--            SELECT 
--                st_union(geometrie) AS geometrie 
--            FROM 
--                afu_naturgefahren_staging_v2.gefahrengebiet_hauptprozess_rutschung
--        ) hauptprozess
)

,water AS ( 
    SELECT 
        'water' AS main_process,
        CASE
            WHEN gefahrenstufe = 'restgefaehrdung'
                THEN 'residual_hazard'
            WHEN gefahrenstufe = 'gering'
                THEN 'slight'
            WHEN gefahrenstufe = 'mittel'
                THEN 'mean'
            WHEN gefahrenstufe = 'erheblich'
                THEN 'substantial'
        END AS hazard_level,
        'complete' AS subprocesses_complete,    
        'complete' AS sources_complete, 
        (st_dump(geometrie)).geom AS impact_zone,
        CAST('SO' AS VARCHAR) AS data_responsibility,
        NULL AS comments
    FROM 
        afu_naturgefahren_staging_v2.gefahrengebiet_hauptprozess_wasser 
--    UNION ALL 
--    SELECT
--        'water' AS main_process,
--        'not_in_danger' AS hazard_level,
--        'complete' AS subprocesses_complete,    
--        'complete' AS sources_complete, 
--        st_difference(erhebungsgebiet.geometrie,hauptprozess.geometrie) AS impact_zone,
--        CAST('SO' AS VARCHAR) AS data_responsibility,
--        NULL AS comments
--    FROM 
--        beurteilungsgebiet_wasser erhebungsgebiet, 
--        (
--            SELECT 
--                st_union(geometrie) AS geometrie 
--            FROM 
--                afu_naturgefahren_staging_v2.gefahrengebiet_hauptprozess_wasser
--        ) hauptprozess   
)
   
INSERT INTO 
    afu_naturgefahren_mgdm_v1.hazard_mapping_hazard_area (
        t_ili_tid,
        main_process, 
        hazard_level, 
        subprocesses_complete, 
        sources_complete, 
        impact_zone, 
        data_responsibility, 
        "comments"
    )

    SELECT 
        uuid_generate_v4() AS t_ili_tid,
        main_process, 
        hazard_level, 
        subprocesses_complete, 
        sources_complete, 
        (st_dump(st_reducePrecision(impact_zone,0.001))).geom AS impact_zone, 
        data_responsibility, 
        "comments" 
    FROM 
        rockfall 
    UNION ALL 
    SELECT 
        uuid_generate_v4() AS t_ili_tid,
        main_process, 
        hazard_level, 
        subprocesses_complete, 
        sources_complete, 
        (st_dump(st_reducePrecision(impact_zone,0.001))).geom AS impact_zone, 
        data_responsibility, 
        "comments" 
    FROM 
        landslide 
    UNION ALL 
    SELECT 
        uuid_generate_v4() AS t_ili_tid,
        main_process, 
        hazard_level, 
        subprocesses_complete, 
        sources_complete, 
        (st_dump(st_reducePrecision(impact_zone,0.001))).geom AS impact_zone, 
        data_responsibility, 
        "comments" 
    FROM 
        water 
;

UPDATE afu_naturgefahren_mgdm_v1.hazard_mapping_hazard_area 
SET t_ili_tid = concat('_',t_ili_tid,'.so.ch')::text
;

DELETE FROM afu_naturgefahren_mgdm_v1.hazard_mapping_hazard_area 
WHERE ST_Isempty(impact_zone) = true
; 