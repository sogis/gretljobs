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
    obj_grundwasserwaerme_.subtyp, 
    obj_grundwasserwaerme_.schachttyp, 
    obj_grundwasserwaerme_.limnigraf, 
    obj_grundwasserwaerme_.zustand
FROM 
    vegas.obj_objekt
    NATURAL JOIN vegas.obj_grundwasserwaerme_
WHERE
    obj_objekt.archive = 0
;
