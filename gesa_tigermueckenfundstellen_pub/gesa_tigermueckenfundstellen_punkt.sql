SELECT 
	trapid,
	plz || ' ' || ort AS Ort,
	standort,
	lv95_e,
	lv95_n,
	positiv,
	n_individuen,
	art,
	ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie
FROM 
	gesa_tigermueckenfundstellen_v1.csv_import