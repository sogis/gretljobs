SELECT
	t_ili_tid::varchar AS t_ili_tid,	
	CASE
		WHEN prozessa = 'Sturz'
			THEN 'rockfall'
		WHEN prozessa = 'Rutschung'
			THEN 'landslide'
		WHEN prozessa = 'Wasser'
			THEN 'water'
		WHEN prozessa = 'Lawine'
			THEN 'avalanche'
		ELSE 'MAPPING_ERROR'
	END AS main_process,
	CASE
		WHEN gef_stufe = 'keine'
			THEN 'not_in_danger'
		WHEN gef_stufe = 'vorhanden'
			THEN 'residual_hazard'
		WHEN gef_stufe = 'gering'
			THEN 'slight'
		WHEN gef_stufe = 'mittel'
			THEN 'mean'
		WHEN gef_stufe = 'erheblich'
			THEN 'substantial'
		ELSE 'MAPPING_ERROR'
	END AS hazard_level,
	'complete' AS subprocesses_complete,	
	'complete' AS sources_complete,	
    CAST('SO' AS VARCHAR) AS data_responsibility,
    bemerkung AS comments,
    geometrie AS impact_zone
FROM afu_gefahrenkartierung.gk_mgdm
LIMIT ALL
;


      
  


    



    

    

     
    
    
    
     
    