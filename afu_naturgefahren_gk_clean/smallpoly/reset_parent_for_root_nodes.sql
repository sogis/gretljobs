

UPDATE 
    poly_cleanup 
SET 
    parent_id = NULL 
WHERE 
    parent_id = id
;