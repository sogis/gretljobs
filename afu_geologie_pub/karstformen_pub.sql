SELECT
    geometrie,     
    typ,
    code.dispname AS typ_txt
FROM 
    afu_geologie_v1.geologie_karstformen AS karstformen
    LEFT JOIN afu_geologie_v1.geologie_karstformen_typ AS code
    ON karstformen.typ = code.ilicode
;
