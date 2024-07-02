INSERT INTO 
    afu_naturgefahren_mgdm_v1.hazard_mapping_synoptic_intensity (
        t_ili_tid,
        impact_zone, 
        data_responsibility, 
        "comments",
        intensity_class, 
        process_cantonal_term, 
        return_period_in_years, 
        extreme_scenario, 
        subproc_synoptic_intensity, 
        sources_in_subprocesses_compl 
    )

SELECT 
    uuid_generate_v4() AS t_ili_tid,
    (ST_Dump(geometrie)).geom AS impact_zone,
    'SO' AS data_responsibility,
    NULL AS comments,
    CASE 
        WHEN intensitaet = 'keine_einwirkung'
        THEN 'no_impact'
        WHEN intensitaet = 'einwirkung_vorhanden'
        THEN 'existing_impact'
        WHEN intensitaet = 'schwach'
        THEN 'low'
        WHEN intensitaet = 'mittel'
        THEN 'mean'
        WHEN intensitaet = 'stark'
        THEN 'high'
        ELSE 'MAPPING_ERROR' --mapping error, case statement must not go in else block
    END AS intensity_class,
    teilprozess AS process_cantonal_term,
    CASE 
        WHEN jaehrlichkeit = -1 THEN NULL 
        ELSE jaehrlichkeit
    END AS return_period_in_years,
    CASE
        WHEN jaehrlichkeit >= 300
        THEN true
        ELSE false
    END AS extreme_scenario,
    CASE
        WHEN teilprozess = 'ufererosion'
        THEN 'w_bank_erosion'
        WHEN teilprozess = 'ueberschwemmung'
        THEN 'w_flooding'
        WHEN teilprozess = 'uebermurung'
        THEN 'w_debris_flow'
        WHEN teilprozess = 'stein_blockschlag'
        THEN 'r_rock_fall'
        WHEN teilprozess = 'spontane_rutschung'
        THEN 'l_sud_spontaneous_landslide'
        WHEN teilprozess = 'permanente_rutschung'
        THEN 'l_permanent_landslide'
        WHEN teilprozess = 'hangmure'
        THEN 'l_sud_hillslope_debris_flow'
        WHEN teilprozess = 'fels_bergsturz'
        THEN 'r_rock_slide_rock_avalanche'
        WHEN (teilprozess = 'einsturz_absenkung') OR  (teilprozess = 'absenkung') OR  (teilprozess = 'einsturz')
        THEN 'sinkhole_or_subsidence'
        ELSE 'MAPPING_ERROR' --mapping error, case statement must not go in else block
    END AS subproc_synoptic_intensity,
    CAST('complete' AS VARCHAR) AS sources_in_subprocesses_compl
FROM 
    afu_naturgefahren_staging_v1.synoptische_intensitaet
; 

UPDATE 
    afu_naturgefahren_mgdm_v1.hazard_mapping_synoptic_intensity
SET 
    t_ili_tid = concat('_',t_ili_tid,'.so.ch')::text
;

UPDATE
    afu_naturgefahren_mgdm_v1.hazard_mapping_synoptic_intensity 
SET 
    impact_zone = st_reducePrecision(impact_zone,0.001)
;

DELETE FROM 
    afu_naturgefahren_mgdm_v1.hazard_mapping_synoptic_intensity 
WHERE 
    ST_Isempty(impact_zone) = true
; 