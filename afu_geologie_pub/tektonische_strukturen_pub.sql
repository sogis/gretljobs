SELECT
    ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(geometrie, 0.0001))) AS geometrie, 
    typ,
    typ.dispname AS typ_txt
FROM 
    afu_geologie_v1.geologie_tektonische_strukturen AS tektonische_strukturen
    LEFT JOIN afu_geologie_v1.geologie_tektonische_strukturen_typ AS typ
    ON tektonische_strukturen.typ = typ.ilicode
;
