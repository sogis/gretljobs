/* Erstellt das assessment_area aufgrund der Siedlungsgebiete in afu_gefahrenkartierung.erhebungsgebiet.
 * Für die Gebiete zwischen den Siedlungsgebieten wird dynamisch ein Polygon erzeugt, zwecks Erfüllung
 * der Vorgaben des MGDM.
 * */
WITH
	assessed_area_one_multipoly AS (
		SELECT 
			ST_Multi(ST_Collect(ST_ForceSFS(geometrie))) AS geometrie
		FROM
			(SELECT geometrie FROM afu_gefahrenkartierung.erhebungsgebiet) AS suquery
		
	),
	not_assessed_area AS (
		SELECT 
			nextval('afu_gefahrenkartierung_stage_mgdm.t_ili2db_seq') AS t_id,
		    'ch.so.afu_gefahrenkartierung.not_assessed'::varchar AS t_ili_tid,
			ST_AsBinary(ST_Difference(kantonsgrenze.geometrie, assessed_area_one_multipoly.geometrie)) AS area,			
			'SO'::text AS data_responsibility,
			'not_assessed'::text AS fl_state_flooding,
			'not_assessed'::text AS df_state_debris_flow,
			'not_assessed'::text AS be_state_bank_erosion,
			'not_assessed'::text AS pl_state_permanent_landslide,
			'not_assessed'::text AS sl_state_spontaneous_landslide,
			'not_assessed'::text AS hd_state_hillslope_debris_flow,
			'not_assessed'::text AS rf_state_rock_fall,
			'not_assessed'::text AS rs_state_rock_slide_rock_aval,
			'not_assessed'::text AS sh_state_sinkhole,
			'not_assessed'::text AS su_state_subsidence,
			'not_assessed'::text AS fa_state_flowing_avalanche,
			'not_assessed'::text AS pa_state_powder_avalanche,
			'not_assessed'::text AS gs_state_gliding_snow,
			'not_assessed'::text AS if_state_ice_fall
		FROM 
			afu_gefahrenkartierung_stage_mgdm.kantonsgrenze,
			assessed_area_one_multipoly			
	),
	assessed_area AS (
		SELECT
			nextval('afu_gefahrenkartierung_stage_mgdm.t_ili2db_seq') AS t_id,
			t_ili_tid::text AS t_ili_tid,
			ST_AsBinary(geometrie) AS area,
			'SO'::text AS data_responsibility,
			'assessed_and_complete'::text AS fl_state_flooding,
			'assessed_and_complete'::text AS df_state_debris_flow,
			'assessed_and_complete'::text AS be_state_bank_erosion,
			'assessed_and_complete'::text AS pl_state_permanent_landslide,
			'assessed_and_complete'::text AS sl_state_spontaneous_landslide,
			'assessed_and_complete'::text AS hd_state_hillslope_debris_flow,
			'assessed_and_complete'::text AS rf_state_rock_fall,
			'assessed_and_complete'::text AS rs_state_rock_slide_rock_aval,
			'assessed_and_complete'::text AS sh_state_sinkhole,
			'assessed_and_complete'::text AS su_state_subsidence,
			'assessed_and_complete'::text AS fa_state_flowing_avalanche,
			'assessed_and_complete'::text AS pa_state_powder_avalanche,
			'assessed_and_complete'::text AS gs_state_gliding_snow,
			'assessed_and_complete'::text AS if_state_ice_fall
		FROM afu_gefahrenkartierung.erhebungsgebiet
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
