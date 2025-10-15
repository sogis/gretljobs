/*
Über _parent_id_ref und id ist der Bezug eines Polygons der aktuellen Generation auf das 
Mutter-Polygon der Vor-Generation gegeben.
Dieses Query setzt für alle nodes inkl. der root nodes die _root_id_ref.
*/

-- Gibt für jeden node die id des root-nodes aus. 
-- Für die root-nodes ist _parent_id_ref NULL
WITH 

RECURSIVE node_parent_root_map AS (
    SELECT
        id,
        _parent_id_ref,
        id AS _root_id_ref
    FROM 
        poly_cleanup
    WHERE 
        _parent_id_ref IS NULL  -- Root nodes

    UNION ALL

    SELECT
        n.id,
        n._parent_id_ref,
        r._root_id_ref
    FROM 
        poly_cleanup n
    JOIN 
        node_parent_root_map r ON n._parent_id_ref = r.id
)

UPDATE 
    poly_cleanup p
SET 
    _root_id_ref = r._root_id_ref
FROM 
    node_parent_root_map r
WHERE 
        p.id = r.id
    AND
        p._parent_id_ref IS NOT NULL
;