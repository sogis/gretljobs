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
    obj_bohrung_.bohrtyp, 
    obj_bohrung_.bohr_durchmesser, 
    obj_bohrung_.obere_hoehe, 
    obj_bohrung_.obere_hoehe_bez, 
    obj_bohrung_.tiefe, 
    obj_bohrung_.sohle, 
    obj_bohrung_.rohr_durchmesser, 
    obj_bohrung_.uk_rohr, 
    obj_bohrung_.ok_rohr, 
    obj_bohrung_.limnigraf, 
    obj_bohrung_.piezometer
FROM 
    vegas.obj_objekt
    NATURAL JOIN vegas.obj_bohrung_
WHERE
    obj_objekt.archive = 0
;
