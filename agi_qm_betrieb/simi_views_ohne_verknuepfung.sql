ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE simiViewsOhneVerknuepfung AS
SELECT 
    sdp.ident_part AS Layername
FROM 
	simidb.simi.simiproduct_data_product sdp 
    LEFT JOIN simidb.simi.simiproduct_single_actor ssa 
    ON ssa.id = sdp.id
    JOIN simidb.simi.simiproduct_data_product_pub_scope sdpps
    ON sdpps.id = sdp.pub_scope_id
    JOIN simidb.simi.simidata_data_set_view sdsv 
    ON sdsv.id = sdp.id 
WHERE 
    sdp.dtype IN ('simiData_TableView','simiData_RasterView') 
    AND sdpps.display_text = 'Nicht (selbst) publiziert'
    AND sdp.ident_part NOT LIKE '%data' 
    AND sdp.ident_part NOT LIKE '%bezug'
    AND NOT EXISTS (
        SELECT
            1
        FROM 
        	simidb.simi.simiproduct_properties_in_list spil
        WHERE 
        	sdp.id = spil.single_actor_id
    )
    AND NOT EXISTS (
        SELECT
            1
        FROM 
        	simidb.simi.simiproduct_properties_in_facade spif
        WHERE 
        	sdp.id = spif.data_set_view_id
    )
    AND NOT EXISTS (
        SELECT
            1
        FROM 
        	simidb.simi.simiextended_relation sr
        WHERE 
        	sdp.id = sr.data_set_view_id
    )
    AND sdsv.is_file_download_dsv IS FALSE
    AND sdsv.service_download  IS FALSE
ORDER BY 
	sdp.ident_part
;

COPY simiViewsOhneVerknuepfung TO '/tmp/qmbetrieb/simi_views_ohne_verknuepfung.csv' (HEADER, DELIMITER ';');