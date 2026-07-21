DELETE FROM
	${dbSchema}.csv_import
WHERE
	jahr = ${importYear}
OR 
	jahr IS NULL
;