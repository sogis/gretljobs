

UPDATE 
    poly_cleanup 
SET 
    parent_id_ref = NULL 
WHERE 
    parent_id_ref = id
;