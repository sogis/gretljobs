SET file_search_path = ${csv_dir_quoted}
;
CREATE OR REPLACE TABLE 
	neophyten 
AS 
SELECT 
	*
FROM 
	'data.csv'
WHERE
	presence IN (681, 686)
;