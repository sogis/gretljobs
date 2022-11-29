-- Helper-Skript zur Erzeugung der DELETE und TransferSet-Statements

WITH 

tbl AS (
	SELECT 
		'copy/data/' AS folder,
		tbl,
		ROW_NUMBER() OVER() AS rownum
	FROM (
		VALUES		
		('simitheme_theme_publication_custom_file_type_link')		
		,('simitheme_file_type')	
		,('simitheme_theme_publication')
		,('simitheme_theme')
		,('simitheme_sub_org')
		,('simitheme_agency')
		,('simitheme_org_unit')
	)
	AS t(tbl)
),

parts AS (
	SELECT 
		array_to_string( 
			array_remove( 
				string_to_array(tbl, '_'),
				split_part(tbl, '_', 1)
			),
			'_'
		) AS filename_prefix,
		'simi.' || tbl AS tbl_full,
		tbl.*
	FROM
		tbl
),

tset AS (
	SELECT
		concat('new TransferSet(''', folder, filename_prefix, '.sql', ''', ''', tbl_full, ''', false),') AS tset
	FROM 
		parts
	ORDER BY 
		rownum desc

),

del AS (
	SELECT
		concat('DELETE FROM ', tbl_full, ';') AS del
	FROM 
		parts
	ORDER BY 
		rownum asc
)

SELECT * FROM tset



