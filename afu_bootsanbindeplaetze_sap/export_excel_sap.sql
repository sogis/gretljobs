COPY (
	SELECT
		*
	FROM
		afu_bootsanbindeplaetze.main.sap_structure)
TO ${excelPathSAP} WITH (FORMAT GDAL, DRIVER 'xlsx');