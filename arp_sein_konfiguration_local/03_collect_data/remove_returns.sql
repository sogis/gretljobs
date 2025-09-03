UPDATE main.sein_sammeltabelle_filtered
	SET information = REPLACE(information, CHR(10), '')
WHERE
	information LIKE '%' || CHR(10) || '%';