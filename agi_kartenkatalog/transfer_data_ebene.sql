WITH parents AS 
(
    SELECT 
        dp.id,
        dp.dtype,
        dp.description,
        pg.description_override,
        pg.description_model,
        dp.remarks,
        dp.title,
        dp.ident_part,
        dp.derived_identifier,
        dp.keywords,
        dp.synonyms,
        ps.display_text,
        dsw.style_server,
        dsw.service_download,
        sa.transparency,
        st.title AS theme_title,
        st.identifier AS theme_ident,
        sou."name" AS org_name,
        --json(list(r."name") FILTER (WHERE r."name" IS NOT NULL)) AS permissions--,
        json_agg(r."name") FILTER (WHERE r."name" IS NOT NULL) AS permissions
    FROM 
        simi.simiproduct_data_product AS dp 
        LEFT JOIN simi.simiproduct_data_product_pub_scope AS ps 
        ON dp.pub_scope_id = ps.id 
        LEFT JOIN simi.simidata_data_set_view AS dsw 
        ON dsw.id = dp.id
        LEFT JOIN simi.simiproduct_single_actor AS sa  
        ON sa.id = dp.id
        LEFT JOIN simi.simiiam_permission AS perm
        ON perm.data_set_view_id = dsw.id
        LEFT JOIN simi.simiiam_role AS r 
        ON perm.role_id = r.id
        LEFT JOIN simi.simitheme_theme_publication AS stp 
        ON dp.theme_publication_id = stp.id 
        LEFT JOIN simi.simitheme_theme AS st 
        ON stp.theme_id = st.id
        LEFT JOIN simi.simitheme_org_unit AS sou 
        ON st.data_owner_id = sou.id
        LEFT JOIN simi.simidata_table_view AS tv 
        ON dp.id = tv.id 
        LEFT JOIN simi.simidata_postgres_table AS pg 
        ON tv.postgres_table_id = pg.id

    WHERE 
        dp.dtype IN ('simiProduct_LayerGroup')
        AND
        ps.display_text IN ('WGC, QGIS u. WMS', 'Nur WMS', 'WGC u. QGIS')
    GROUP BY 
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18
)
,
children AS 
(
    SELECT 
        lg.id AS lg_id,
        dp.id,
        dp.dtype,
        dp.description,
        pg.description_override,
        pg.description_model,
        dp.remarks,
        dp.title,
        dp.ident_part,
        dp.derived_identifier,
        dp.keywords,
        dp.synonyms,
        ps.display_text,
        dsw.style_server,
        dsw.service_download,
        sa.transparency,
		hashtextextended(st.id::text, 0) & 9223372036854775807::bigint AS thema_r,                
        st.title AS theme_title,
        st.identifier AS theme_ident,
        sou."name" AS org_name,
        --json(list(r."name") FILTER (WHERE r."name" IS NOT NULL)) AS permissions--,
        json_agg(r."name") FILTER (WHERE r."name" IS NOT NULL) AS permissions
    FROM 
        simi.simiproduct_layer_group AS lg 
        LEFT JOIN simi.simiproduct_properties_in_list AS pil 
        ON lg.id = pil.product_list_id
        LEFT JOIN simi.simiproduct_data_product AS dp 
        ON pil.single_actor_id = dp.id 
        LEFT JOIN simi.simiproduct_data_product_pub_scope AS ps 
        ON dp.pub_scope_id = ps.id 
        LEFT JOIN simi.simidata_data_set_view AS dsw 
        ON dsw.id = dp.id
        LEFT JOIN simi.simiproduct_single_actor AS sa  
        ON sa.id = dp.id
        LEFT JOIN simi.simiiam_permission AS perm
        ON perm.data_set_view_id = dsw.id
        LEFT JOIN simi.simiiam_role AS r 
        ON perm.role_id = r.id
        LEFT JOIN simi.simitheme_theme_publication AS stp 
        ON dp.theme_publication_id = stp.id 
        LEFT JOIN simi.simitheme_theme AS st 
        ON stp.theme_id = st.id
        LEFT JOIN simi.simitheme_org_unit AS sou 
        ON st.data_owner_id = sou.id
        LEFT JOIN simi.simidata_table_view AS tv 
        ON dp.id = tv.id 
        LEFT JOIN simi.simidata_postgres_table AS pg 
        ON tv.postgres_table_id = pg.id

    GROUP BY 
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
),
layergroup_layers_and_root_layers AS (
	SELECT DISTINCT ON (c.id)
		hashtextextended(c.id::text, 0) & 9223372036854775807::bigint AS t_id,
	    c.dtype AS dtype,
	    c.description AS adescription,
	    c.description_override AS description_override,
	    c.description_model AS description_model,
	    c.remarks AS remarks,
	    c.title AS title,
	    c.ident_part AS ident_part,
	    c.derived_identifier AS derived_identifier,
	    c.keywords AS keywords,
	    c.synonyms AS synonyms,
	    c.display_text AS display_text,
	    c.style_server AS style_server,
	    c.service_download AS service_download,
	    c.transparency AS transparency,
		c.thema_r,    
	    c.theme_title AS theme_title,
	    c.theme_ident AS theme_ident,
	    c.org_name AS org_name,
	    c.permissions AS permissions
	FROM
	    parents AS p 
	    LEFT JOIN children AS c
	    ON p.id = c.lg_id

	UNION ALL    
	    
	SELECT 
		hashtextextended(dp.id::text, 0) & 9223372036854775807::bigint AS t_id,
	    dp.dtype,
	    dp.description AS adescription,
	    pg.description_override,
	    pg.description_model,
	    dp.remarks,
	    dp.title,
	    dp.ident_part,
	    dp.derived_identifier,
	    dp.keywords,
	    dp.synonyms,
	    ps.display_text,
	    dsw.style_server,
	    dsw.service_download,
	    sa.transparency,
		hashtextextended(st.id::text, 0) & 9223372036854775807::bigint AS thema_r,        
	    st.title AS theme_title,
	    st.identifier AS theme_ident,
	    sou."name" AS org_name,
	    --json(list(r."name") FILTER (WHERE r."name" IS NOT NULL)) AS permissions--,
	    json_agg(r."name") FILTER (WHERE r."name" IS NOT NULL) AS permissions
	FROM 
	    simi.simiproduct_data_product AS dp 
	    LEFT JOIN simi.simiproduct_data_product_pub_scope AS ps 
	    ON dp.pub_scope_id = ps.id 
	    LEFT JOIN simi.simidata_data_set_view AS dsw 
	    ON dsw.id = dp.id
	    LEFT JOIN simi.simiproduct_single_actor AS sa  
	    ON sa.id = dp.id
	    LEFT JOIN simi.simiiam_permission AS perm
	    ON perm.data_set_view_id = dsw.id
	    LEFT JOIN simi.simiiam_role AS r 
	    ON perm.role_id = r.id
	    LEFT JOIN simi.simitheme_theme_publication AS stp 
	    ON dp.theme_publication_id = stp.id 
	    LEFT JOIN simi.simitheme_theme AS st 
	    ON stp.theme_id = st.id
	    LEFT JOIN simi.simitheme_org_unit AS sou 
	    ON st.data_owner_id = sou.id
	    LEFT JOIN simi.simidata_table_view AS tv 
	    ON dp.id = tv.id 
	    LEFT JOIN simi.simidata_postgres_table AS pg 
	    ON tv.postgres_table_id = pg.id
	WHERE 
	    dp.dtype NOT IN ('simiProduct_Map', 'simiProduct_LayerGroup')
	    AND
	    ps.display_text IN ('WGC, QGIS u. WMS', 'Nur WMS', 'WGC u. QGIS')
	GROUP BY 
	    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
)
SELECT DISTINCT ON (t_id)
	*
FROM 
	layergroup_layers_and_root_layers
;