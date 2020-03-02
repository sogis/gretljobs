SELECT 
	t_id, 
	t_ili_tid, 
	wkp, 
	int_stufe, 
	teilproz, 
	bez_kanton, 
	bemerkung, 
	geometrie
FROM 
	afu_gefahrenkartierung.gefahrenkartirung_ik_synoptisch_mgdm
WHERE
	int_stufe != 'keine'
;
