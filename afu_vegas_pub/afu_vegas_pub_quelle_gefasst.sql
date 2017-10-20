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
    obj_quelle_gefasst_.verwendung, 
    obj_quelle_gefasst_.limnigraf, 
    obj_quelle_gefasst_.min_schuettung, 
    obj_quelle_gefasst_.max_schuettung, 
    obj_quelle_gefasst_.nutzungsart_schutzzone, 
    obj_quelle_gefasst_.zustand, 
    obj_quelle_gefasst_.rechtsstand_gwba, 
    obj_quelle_gefasst_.pflichten_gwba, 
    obj_quelle_gefasst_.schutzzone, 
    obj_quelle_gefasst_.mittlere_schuettung
FROM 
	vegas.obj_objekt
	NATURAL JOIN 
		vegas.obj_quelle_gefasst_
WHERE
	obj_objekt."archive" = 0;