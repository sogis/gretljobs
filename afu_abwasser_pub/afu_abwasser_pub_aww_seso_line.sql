SELECT 
    aww_seso.oid AS v_oid, 
    aww_seso.ogc_fid AS t_id, 
    aww_seso.durchmesse AS durchmesser, 
    aww_seso.length AS laenge, 
    aww_seso.ogc_fid AS line_fid, 
    aww_seso.wkb_geometry AS geometrie, 
    aww_seso.kategorie, 
    eigentum.code_text AS eigentum, 
    geo_gemeinden.gmde_name, 
    aww_seso_ara.eigentum AS ara_eigentum, 
    aww_seso_ara.gmde_name AS ara_name
FROM 
    aww_seso
    LEFT JOIN aww_seso_ara 
        ON aww_seso.ara_join = aww_seso_ara.cat, 
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
    ) eigentum
WHERE 
    aww_seso.gemeinde = geo_gemeinden.gmde_nr 
    AND 
    eigentum.code_id = aww_seso.eigentum
;