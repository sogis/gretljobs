

UPDATE 
    poly_cleanup 
SET 
    _parent_id_ref = NULL 
WHERE 
    _parent_id_ref = id
;