SELECT 
	geometrie AS impact_zone,
	concat('_',t_ili_tid,'.so.ch')::varchar AS t_ili_tid,
	'SO' AS data_responsibility,
	bemerkung AS comments,
	CASE 
		WHEN int_stufe = 'keine'
			THEN 'no_impact'
		WHEN int_stufe = 'vorhanden'
			THEN 'existing_impact'
		WHEN int_stufe = 'schwach'
			THEN 'low'
		WHEN int_stufe = 'mittel'
			THEN 'mean'
		WHEN int_stufe = 'stark'
			THEN 'high'
		ELSE 'MAPPING_ERROR' --mapping error, case statement must not go in else block
	END AS intensity_class,
	bez_kanton AS process_cantonal_term,
	CASE
		WHEN wkp = 'von_0_bis_30_Jahre'
			THEN 30
		WHEN wkp = 'von_30_bis_100_Jahre'
			THEN 100
		WHEN wkp = 'von_100_bis_300_Jahre'
			THEN 300
		WHEN wkp = 'groesser_300_Jahre'
			THEN 500
		WHEN wkp IS NULL
			THEN NULL
		ELSE -9999  --mapping error, case statement must not go in else block
	END AS return_period_in_years,
	CASE
		WHEN wkp = 'groesser_300_Jahre'
			THEN true
		ELSE false
	END AS extreme_scenario,
	CASE
		WHEN teilproz = 'Ufererosion'
			THEN 'w_bank_erosion'
		WHEN teilproz = 'Ueberschwemmung'
			THEN 'w_flooding'
		WHEN teilproz = 'Uebermurung'
			THEN 'w_debris_flow'
		WHEN teilproz = 'Steinschlag_Blockschlag'
			THEN 'r_rock_fall'
		WHEN teilproz = 'spontane_Rutschung'
			THEN 'l_sud_spontaneous_landslide'
		WHEN teilproz = 'permanente_Rutschung'
			THEN 'l_permanent_landslide'
		WHEN teilproz = 'Hangmure'
			THEN 'l_sud_hillslope_debris_flow'
		WHEN teilproz = 'Felssturz_Bergsturz'
			THEN 'r_rock_slide_rock_avalanche'
		WHEN teilproz = 'Einsturz_Absenkung'
			THEN 'sinkhole_or_subsidence'
		ELSE 'MAPPING_ERROR' --mapping error, case statement must not go in else block
	END AS subproc_synoptic_intensity,
	CAST('complete' AS VARCHAR) AS sources_in_subprocesses_compl
FROM 
	afu_gefahrenkartierung.gefahrenkartirung_ik_synoptisch_mgdm
;   
