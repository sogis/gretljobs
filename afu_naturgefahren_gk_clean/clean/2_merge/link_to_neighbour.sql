/*
Selektiert die parent_nodes über die Where-Clause "_node_position = MAX(_node_position)"
und die möglichen child_nodes über die Where-Clause "_node_position IS NULL",
Das sql kann mehr als einmal ausgeführt werden, um schrittweise auch weiter von den Grosspolygonen entfernte Kleinpolygone
zu verknüpfen.
*/

WITH 

parent AS (
    SELECT 
        MAX(_node_position) AS nodeposition
    FROM 
        public.poly_cleanup 
)

,intersecting AS ( 
    -- INTERSECT aller Polygone ohne _parent_id_ref mit allen Polygonen mit _parent_id_ref.
    -- Berücksichtigt die zulässigen Gefahrenstufen-Unterschiede (Auflösen in kleinere Gefahrenstufe verboten).
    -- merge_rank ist klein bei kleinem Unterschied der Gefahrenstufen unlinked - linked
    SELECT 
        child_candidate.id AS child_id,
        parent.id AS parent_id,
        parent._hazard_level - child_candidate._hazard_level AS _parent_level_diff,
        ROW_NUMBER() OVER (PARTITION BY child_candidate.id ORDER BY parent._hazard_level - child_candidate._hazard_level ASC) AS merge_rank
    FROM 
    (
        SELECT 
            *
        FROM 
            public.poly_cleanup 
        WHERE
            _node_position IS NULL 
    ) AS child_candidate
    ,(
        SELECT 
            *
        FROM 
            public.poly_cleanup p,
            parent g
        WHERE
            p._node_position = g.nodeposition -- Bewirkt, dass nur die aktuellen Leaf-Nodes als Parents berücksichtigt werden
    ) AS parent
    WHERE 
            ST_Intersects(child_candidate.geometrie, parent.geometrie)
        AND 
            child_candidate._hazard_level <= parent._hazard_level
)

UPDATE -- Setzen der Attribute für die Child-Polygone
    public.poly_cleanup t
SET 
    _parent_id_ref = i.parent_id,
    _parent_level_diff = i._parent_level_diff,
    _node_position = g.nodeposition + 1
FROM 
    intersecting i,
    parent g
WHERE 
        t.id = i.child_id
    AND 
        i.merge_rank = 1   
;