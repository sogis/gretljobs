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
        dp.dtype NOT IN ('simiProduct_Map')
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
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
)
SELECT 
    p.id AS p_id,
    p.dtype AS p_dtype,
    p.description AS p_description,
    p.description_override AS p_description_override,
    p.description_model AS p_description_model,
    p.remarks AS p_remarks,
    p.title AS p_title,
    p.ident_part AS p_ident_part,
    p.derived_identifier AS p_derived_identifier,
    p.keywords AS p_keywords,
    p.synonyms AS p_synonyms,
    p.display_text AS p_display_text,
    p.style_server AS p_style_server,
    p.service_download AS p_service_download,
    p.transparency AS p_transparency,
    p.theme_title AS p_theme_title,
    p.theme_ident AS p_theme_ident,
    p.org_name AS p_org_name,
    p.permissions AS p_permissions,
    c.id AS c_id,
    c.dtype AS c_dtype,
    c.description AS c_description,
    c.description_override AS c_description_override,
    c.description_model AS c_description_model,
    c.remarks AS c_remarks,
    c.title AS c_title,
    c.ident_part AS c_ident_part,
    c.derived_identifier AS c_derived_identifier,
    c.keywords AS c_keywords,
    c.synonyms AS c_synonyms,
    c.display_text AS c_display_text,
    c.style_server AS c_style_server,
    c.service_download AS c_service_download,
    c.transparency AS c_transparency,
    c.theme_title AS c_theme_title,
    c.theme_ident AS c_theme_ident,
    c.org_name AS c_org_name,
    c.permissions AS c_permissions
FROM
    parents AS p 
    LEFT JOIN children AS c
    ON p.id = c.lg_id
ORDER BY 
    p.title, c.title   
;