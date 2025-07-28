SET file_search_path = ${root_dir_quoted}
;

INSERT INTO sein.main.sein_sammeltabelle(
	thema_sql,
	information,
	link,
	geometrie
)

SELECT 
	thema_sql,
	information,
	link,
	ST_GeomFromText(geometrie) AS geometrie
FROM
	read_parquet('02_import_data/*/build/theme_sammeltabelle.parquet', union_by_name = true)
;