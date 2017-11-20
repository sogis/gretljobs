SELECT 
    obj_objekt.vegas_id AS t_id, 
    obj_objekt.objekttyp_id, 
    obj_objekt.mobj_id, 
    obj_objekt.bezeichnung, 
    obj_objekt.beschreibung, 
    obj_objekt.aufnahmedatum, 
    obj_objekt.erfasser, 
    obj_objekt.url, 
    obj_objekt.bemerkung,
    obj_objekt.wkb_geometry AS geometrie, 
    obj_filterbrunnen_.subtyp, 
    obj_filterbrunnen_.verwendung, 
    obj_filterbrunnen_.nutzungsart_schutzzone, 
    obj_filterbrunnen_.limnigraf, 
    obj_filterbrunnen_.zustand, 
    obj_filterbrunnen_.schutzzone
FROM 
    vegas.obj_objekt
    NATURAL JOIN vegas.obj_filterbrunnen_
WHERE 
    obj_objekt.archive = 0
;
