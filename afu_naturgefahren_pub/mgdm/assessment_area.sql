/* Erstellt das assessment_area aufgrund der Siedlungsgebiete in afu_gefahrenkartierung.erhebungsgebiet.
 * Die Gebiete zwischen den Siedlungsgebieten sind als Füllpolygone mit dem Bezeichner $OUTSIDE$ im
 * Feld bemerkung von afu_gefahrenkartierung.erhebungsgebiet enthalten.
 * */
WITH
	not_assessed_area AS (
		SELECT 
                        concat('_',t_ili_tid,'.so.ch')::text AS t_ili_tid,
			geometrie AS area,
		   	'SO'::text AS data_responsibility,			
			'not_assessed'::text AS fl_state_flooding,
			'not_assessed'::text AS df_state_debris_flow,
			'not_assessed'::text AS be_state_bank_erosion,
			'not_assessed'::text AS pl_state_permanent_landslide,
			'not_assessed'::text AS sl_state_spontaneous_landslide,
			'not_assessed'::text AS hd_state_hillslope_debris_flow,
			'not_assessed'::text AS rf_state_rock_fall,
			'not_assessed'::text AS rs_state_rock_slide_rock_aval,
			'not_assessed'::text AS fa_state_flowing_avalanche,
			'not_assessed'::text AS pa_state_powder_avalanche,
			'not_assessed'::text AS gs_state_gliding_snow,
			'not_assessed'::text AS su_state_subsidence,
			'not_assessed'::text AS sh_state_sinkhole,
			'not_assessed'::text AS if_state_ice_fall
		FROM 
			afu_gefahrenkartierung.gefahrenkartirung_erhebungsgebiet
		WHERE 
			bemerkung LIKE '%$OUTSIDE$%' 
	),
	assessed_area AS (
		SELECT
			concat('_',t_ili_tid,'.so.ch')::text AS t_ili_tid,
			geometrie AS area,
			'SO'::text AS data_responsibility,			
			'assessed_and_complete'::text AS fl_state_flooding,
			'assessed_and_complete'::text AS df_state_debris_flow,
			'assessed_and_complete'::text AS be_state_bank_erosion,
			'assessed_and_complete'::text AS pl_state_permanent_landslide,
			'assessed_and_complete'::text AS sl_state_spontaneous_landslide,
			'assessed_and_complete'::text AS hd_state_hillslope_debris_flow,
			'assessed_and_complete'::text AS rf_state_rock_fall,
			'assessed_and_complete'::text AS rs_state_rock_slide_rock_aval,
			'assessed_and_complete'::text AS fa_state_flowing_avalanche,
			'assessed_and_complete'::text AS pa_state_powder_avalanche,
			'assessed_and_complete'::text AS gs_state_gliding_snow,
			'assessed'::text AS su_state_subsidence,
			'assessed'::text AS sh_state_sinkhole,
			'assessed'::text AS if_state_ice_fall
		FROM 
			afu_gefahrenkartierung.gefahrenkartirung_erhebungsgebiet
		WHERE bemerkung IS NULL		
			OR bemerkung NOT LIKE '%$OUTSIDE$%'
	)
	

SELECT
	*
FROM 
	not_assessed_area
UNION ALL
SELECT 
	*
FROM
	assessed_area
;
