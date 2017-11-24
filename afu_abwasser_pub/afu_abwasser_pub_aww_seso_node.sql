SELECT 
    aww_seso_node.oid AS v_oid, 
    aww_seso_node.ogc_fid AS t_id, 
    aww_seso_node.ogc_fid AS node_fid, 
    aww_seso_node.wkb_geometry AS geometrie, 
    aww_seso_node.kategorie AS kat_kurz, 
    kategorie.code_text AS kategorie, 
    eigentum.code_text AS eigentum, 
    geo_gemeinden.gmde_name
FROM 
    aww_seso_node, 
    geo_gemeinden_v geo_gemeinden, 
    ( 
        SELECT 
            aww_seso_codes.code_pkey, 
            aww_seso_codes.code_id, 
            aww_seso_codes.code_typ_id, 
            aww_seso_codes.code_text
        FROM 
            aww_seso_codes
        WHERE 
            aww_seso_codes.code_typ_id = 1
    ) eigentum, 
    ( 
        SELECT 
            aww_seso_codes.code_pkey, 
            aww_seso_codes.code_id, 
            aww_seso_codes.code_typ_id, 
            aww_seso_codes.code_text
        FROM 
            aww_seso_codes
        WHERE 
            aww_seso_codes.code_typ_id = 2
    ) kategorie
WHERE 
    aww_seso_node.gemeinde = geo_gemeinden.gmde_nr 
    AND 
    eigentum.code_id = aww_seso_node.eigentum 
    AND 
    kategorie.code_id = aww_seso_node.kategorie_id
;