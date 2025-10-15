COPY (
	SELECT
		*
	FROM
		afu_bootsanbindeplaetze.main.sap_structure)
TO ${excelPath} WITH (FORMAT GDAL, DRIVER 'xlsx');