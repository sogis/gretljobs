SELECT
	*,
	ST_SetSRID(ST_MakePoint(x_koordinate, y_koordinate), 2056) AS geometrie
FROM
	afu_klaeranlagen_v1.klaeranlagen_kleinklaeranlage_import