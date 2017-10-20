SELECT 
	obj_objekt.vegas_id, 
	obj_objekt.objekttyp_id, 
	obj_objekt.mobj_id, 
    obj_objekt.bezeichnung, 
    obj_objekt.beschreibung, 
    obj_objekt.aufnahmedatum, 
    obj_objekt.erfasser, 
    obj_objekt.url, 
    obj_objekt.bemerkung, 
    obj_objekt.wkb_geometry, 
    obj_gerammtes_piezometer_.obere_hoehe, 
    obj_gerammtes_piezometer_.obere_hoehe_bez, 
    obj_gerammtes_piezometer_.limnigraf
FROM 
	vegas.obj_objekt
	NATURAL JOIN 
		vegas.obj_gerammtes_piezometer_
WHERE 
	obj_objekt."archive" = 0;