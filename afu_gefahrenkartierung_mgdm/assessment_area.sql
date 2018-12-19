/* Erstellt das assessment_area aufgrund der Siedlungsgebiete in afu_gefahrenkartierung.erhebungsgebiet.
 * Für die Gebiete zwischen den Siedlungsgebieten wird dynamisch ein Polygon erzeugt, zwecks Erfüllung
 * der Vorgaben des MGDM.
 * 
 * assessed_area_single_multipoly: Kombiniert alle Erhebungsgebiet-Polygone in ein Multipolygon ohne Kurven
 * kantonsgrenze_single_multipoly: Kombiniert alle Kantonsgrenzen-Polygone in ein Multipolygon ohne Kurven (sofern nicht schon ein Multipolygon)
 * not_assessed_area_multipoly: Resultierende singulaere Restflaeche als Multipolygon
 * not_assessed_area: Attributierte Restflaechen als mehrere Einzelpolygone
 * assessed_area: Attributierte Erhebungsflaechen als mehrere Einzelpolygone
 * */
WITH
	assessed_area_single_multipoly AS (
		SELECT 
			public.ST_Multi(public.ST_Collect(public.ST_ForceSFS(geometrie))) AS geometrie
		FROM
			(SELECT geometrie FROM afu_gefahrenkartierung.erhebungsgebiet) AS suquery
	),
	kantonsgrenze_single_multipoly AS (
		SELECT 
			public.ST_Multi(public.ST_Collect(public.ST_ForceSFS(geometrie))) AS geometrie
		FROM
			(SELECT geometrie FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze) AS suquery
	),
	not_assessed_area_multipoly AS (
    		SELECT
    			public.ST_Difference(kantonsgrenze_single_multipoly.geometrie, assessed_area_single_multipoly.geometrie) AS area_multi
    		FROM
    			kantonsgrenze_single_multipoly,
    			assessed_area_single_multipoly
    ),
	not_assessed_area AS (
		SELECT 
		    CAST(uuid_generate_v4() AS varchar) AS t_ili_tid,
		    (ST_Dump(not_assessed_area_multipoly.area_multi)).geom AS area,
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
			not_assessed_area_multipoly
	),
	assessed_area AS (
		SELECT
			t_ili_tid::text AS t_ili_tid,
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
		FROM afu_gefahrenkartierung.erhebungsgebiet
	)
	
SELECT * FROM (
	SELECT
		*
	FROM 
		not_assessed_area
	UNION ALL

	SELECT 
		*
	FROM
		assessed_area
) AS ktso
LIMIT 0
