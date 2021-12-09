SELECT 
    geometrie, 
    orientierung_einfall,
    winkelbetrag_einfall,
    typ,
    code.dispname AS typ_txt
FROM 
    afu_geologie_v1.geologie_schichtfallen AS schichtfallen
    LEFT JOIN afu_geologie_v1.geologie_schichtfallen_typ AS code
    ON schichtfallen.typ = code.ilicode
;
