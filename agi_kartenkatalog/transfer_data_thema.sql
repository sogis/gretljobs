SELECT
	hashtextextended(st.id::text, 0) & 9223372036854775807::bigint AS t_id,        
	st.identifier AS identifier,
	st.title AS title, 
	st.description AS adescription, 
	st.keywords_arr AS keywords,
	st.synonyms_arr AS synonyms,	
	st.further_info_url,
	sou."name" AS data_owner
FROM 
	simi.simitheme_theme AS st 
	LEFT JOIN simi.simitheme_org_unit AS sou 
	ON st.data_owner_id = sou.id
;