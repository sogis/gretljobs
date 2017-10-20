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
    obj_quelle_.min_schuettung, 
    obj_quelle_.max_schuettung, 
    obj_quelle_.schutzzone, 
    obj_quelle_.mittlere_schuettung
FROM 
	vegas.obj_objekt
	NATURAL JOIN 
		vegas.obj_quelle_
WHERE
	obj_objekt."archive" = 0;