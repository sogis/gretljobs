SELECT 
    ogc_fid AS t_id,
    ST_Force_2D(wkb_geometry) AS geometrie,
    gnrso,
    location,
    abschnr,
    bauwnr,
    bauwtyp,
    bauwhoeh,
    erhebungsdatum,
    code_text.text AS bauwtyp_txt
FROM 
    gewisso.oeko_bauwerke
    LEFT JOIN gewisso.code_text
        ON
            code_text.code = oeko_bauwerke.bauwtyp
            AND
            code_text.code_typ_id = 1
WHERE 
    archive = 0
;
