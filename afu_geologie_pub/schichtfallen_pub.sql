SELECT 
    geometrie, 
    orientierung_einfall,
    winkelbetrag_einfall,
    typ
FROM 
    afu_geologie_v1.geologie_schichtfallen AS schichtfallen
    LEFT JOIN afu_geologie_v1.geologie_schichtfallen_typ AS code
    ON schichtfallen.typ = code.ilicode
;
