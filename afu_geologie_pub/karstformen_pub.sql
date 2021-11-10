SELECT
    geometrie,     
    typ
FROM 
    afu_geologie_v1.geologie_karstformen AS karstformen
    LEFT JOIN afu_geologie_v1.geologie_karstformen_typ AS typ
    ON karstformen.typ = typ.ilicode
;
