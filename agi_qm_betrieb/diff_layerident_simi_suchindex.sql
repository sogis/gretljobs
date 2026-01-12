ATTACH ${connectionStringPub} AS pubdb (TYPE POSTGRES, READ_ONLY);
ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);


CREATE TEMP TABLE myresult_diff AS 
(
	SELECT 
	    DISTINCT ON (layer_ident)
	    layer_ident,
	    'pub minus simi' AS kategorie
	FROM 
		pubdb.agi_suchindex_pub_v1.feature
		
	EXCEPT
	
	SELECT 
	    sdp.ident_part,
	    'pub minus simi' AS kategorie
	FROM 
		simidb.simi.simiproduct_data_product sdp
		JOIN simidb.simi.simidata_table_view stv 
	    ON sdp.id = stv.id 
	WHERE 
		dtype = 'simiData_TableView' AND stv.search_type != '1_no_search'
) 	

UNION ALL
(
	SELECT 
	    sdp.ident_part,
	    'simi minus pub' AS kategorie
	FROM 
		simidb.simi.simiproduct_data_product sdp
		JOIN simidb.simi.simidata_table_view stv 
	    ON sdp.id = stv.id 
	WHERE 
		dtype = 'simiData_TableView' AND stv.search_type != '1_no_search'
		
	EXCEPT
				
	SELECT 
	    DISTINCT ON (layer_ident)
	    layer_ident,
	    'simi minus pub' AS kategorie
	FROM 
		pubdb.agi_suchindex_pub_v1.feature
) 	
ORDER BY 
	ident_part ASC
;

COPY (SELECT * FROM myresult_diff) TO '/tmp/qmbetrieb/diff_layerident_simi_suchindex.csv' (HEADER, DELIMITER ';');


