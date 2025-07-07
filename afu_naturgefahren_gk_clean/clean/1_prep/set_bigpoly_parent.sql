UPDATE -- Setzen der Attribute der big polygone
    public.poly_cleanup t
SET 
    _parent_id_ref = t.id
WHERE 
    _is_big IS TRUE
;