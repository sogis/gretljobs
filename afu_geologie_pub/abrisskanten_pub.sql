SELECT
    geometrie,     
    typ,
    code.dispname AS typ_txt
FROM 
    afu_geologie_v1.geologie_abrisskanten AS abrisskanten
    LEFT JOIN afu_geologie_v1.geologie_abrisskanten_typ AS code
    ON abrisskanten.typ = code.ilicode
;
