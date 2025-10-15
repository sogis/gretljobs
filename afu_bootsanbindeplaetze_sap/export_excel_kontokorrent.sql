COPY (
	SELECT
		*
	FROM
		afu_bootsanbindeplaetze.main.kontokorrent_structure)
TO ${excelPathKontokorrent} WITH (FORMAT GDAL, DRIVER 'xlsx');