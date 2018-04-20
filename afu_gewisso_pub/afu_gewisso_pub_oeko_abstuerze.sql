SELECT 
    ogc_fid AS t_id,
    ST_Force_2D(wkb_geometry) AS geometrie,
    gnrso,
    location,
    abschnr,
    abstnr,
    absttyp,
    abstmat,
    absthoeh,
    erhebungsdatum,
    code_text.text AS absttyp_txt,
    abstmat.text AS abstmat_txt
FROM 
    gewisso.oeko_abstuerze
    LEFT JOIN gewisso.code_text
        ON 
            code_text.code = oeko_abstuerze.absttyp 
            AND 
            code_typ_id = 2
    LEFT JOIN gewisso.code_text AS abstmat
        ON 
            abstmat.code = oeko_abstuerze.abstmat 
            AND 
            abstmat.code_typ_id = 3
WHERE 
    archive = 0
;

