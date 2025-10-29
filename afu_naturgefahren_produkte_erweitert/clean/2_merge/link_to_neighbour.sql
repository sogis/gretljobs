/*
Selektiert die parent_nodes über die Where-Clause "_node_generation = MAX(_node_generation)"
und die möglichen child_nodes über die Where-Clause "_node_generation IS NULL",
Das sql kann mehr als einmal ausgeführt werden, um schrittweise auch weiter von den Grosspolygonen entfernte Kleinpolygone
zu verknüpfen.
Siehe "Beschreibung der Schritte des Merge" im readme.md
*/

WITH 

parent AS (
    SELECT 
        MAX(_node_generation) AS nodegeneration
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
        parent._hazard_level - child_candidate._hazard_level AS parent_level_diff,
        ST_Length( -- Länge der bbox als Mass für die Ausdehnung der Intersection
            ST_Boundary(
                ST_Envelope(
                    ST_Intersection(child_candidate.geometrie, parent.geometrie)
                )
            )
        ) AS intersect_bbox_length
    FROM 
    (
        SELECT 
            *
        FROM 
            public.poly_cleanup 
        WHERE
            _node_generation IS NULL 
    ) AS child_candidate
    ,(
        SELECT 
            *
        FROM 
            public.poly_cleanup p,
            parent g
        WHERE
            p._node_generation = g.nodegeneration -- Bewirkt, dass nur die aktuellen Leaf-Nodes als Parents berücksichtigt werden
    ) AS parent
    WHERE 
            ST_Intersects(child_candidate.geometrie, parent.geometrie)
        AND 
            child_candidate._hazard_level <= parent._hazard_level
)

,ranked_candiates AS ( -- Priorisierung der Verschmelzungskandidaten nach: 1. Kleiner _parent_level_diff und 2. Grosser _intersect_bbox_length
    SELECT 
        intersecting.*,
        ROW_NUMBER() OVER (PARTITION BY child_id ORDER BY parent_level_diff ASC, intersect_bbox_length DESC) AS merge_rank
    FROM 
       intersecting 
)

UPDATE -- Setzen der Attribute für die Child-Polygone
    public.poly_cleanup t
SET 
    _parent_id_ref = r.parent_id,
    _parent_level_diff = r.parent_level_diff,
    _intersect_bbox_length = r.intersect_bbox_length,
    _node_generation = g.nodegeneration + 1
FROM 
    ranked_candiates r,
    parent g
WHERE 
        t.id = r.child_id
    AND 
        r.merge_rank = 1   
;