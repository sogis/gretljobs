/*
Über parent_id_ref und id ist der Bezug eines leafnodes-polygon auf das unmittelbare 
parentnode-polygon gegeben.
Dieses Query setzt für alle nodes inkl. der root nodes die root_id_ref
*/

-- Gibt für jeden node die id des root-nodes aus. 
-- Für die root-nodes ist parent_id_ref NULL
WITH 

RECURSIVE node_parent_root_map AS (
    SELECT
        id,
        parent_id_ref,
        id AS root_id_ref
    FROM 
        poly_cleanup
    WHERE 
        parent_id_ref IS NULL  -- Root nodes

    UNION ALL

    SELECT
        n.id,
        n.parent_id_ref,
        r.root_id_ref
    FROM 
        poly_cleanup n
    JOIN 
        node_parent_root_map r ON n.parent_id_ref = r.id
)

UPDATE 
    poly_cleanup p
SET 
    root_id_ref = r.root_id_ref
FROM 
    node_parent_root_map r
WHERE 
        p.id = r.id
    AND
        p.parent_id_ref IS NOT NULL
;