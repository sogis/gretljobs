SELECT
	t_ili_tid, 
	prozessa,
	prozessq,
	wkp, 
	int_stufe,
	bemerkung, 
	gs_korr,
	ngkid, 
	geometrie
FROM 
	afu_gefahrenkartierung.gefahrenkartirung_ik_wasser
WHERE
	int_stufe != 'keine'
;
