/*
Verknüpft alle Polygone ohne parent_id_ref mit Nachbarn mit parent_id_ref.
Vorbedingung der ersten Ausführung dieses SQL ist, dass für die Grosspolygone die parent_id_ref gesetzt (<> NULL) ist
Das sql kann mehr als einmal ausgeführt werden, um schrittweise auch weiter von den Grosspolygonen entfernte Kleinpolygone
zu verknüpfen.
*/

WITH 
intersecting AS ( 
    -- INTERSECT aller Polygone ohne parent_id_ref mit allen Polygonen mit parent_id_ref.
    -- Berücksichtigt die zulässigen Gefahrenstufen-Unterschiede (Auflösen in kleinere Gefahrenstufe verboten).
    -- merge_rank ist klein bei kleinem Unterschied der Gefahrenstufen unlinked - linked
    SELECT 
        unlinked.id AS unlinked_id,
        linked.id AS linked_id,
        linked.hazard_level - unlinked.hazard_level AS parent_level_diff,
        ROW_NUMBER() OVER (PARTITION BY unlinked.id ORDER BY linked.hazard_level - unlinked.hazard_level ASC) AS merge_rank
    FROM 
    (
        SELECT 
            *
        FROM 
            public.poly_cleanup 
        WHERE
            parent_id_ref IS NULL 
    ) AS unlinked
    ,(
        SELECT 
            *
        FROM 
            public.poly_cleanup 
        WHERE
            parent_id_ref IS NOT NULL 
    ) AS linked
    WHERE 
            ST_Intersects(unlinked.singlepoly, linked.singlepoly)
        AND 
            unlinked.hazard_level <= linked.hazard_level
)

UPDATE -- Setzen der parent_id_ref für die bisher "unlinked" Polygone
    public.poly_cleanup t
SET 
    parent_id_ref = i.linked_id,
    parent_level_diff = i.parent_level_diff
FROM 
    intersecting i
WHERE 
        t.id = i.unlinked_id
    AND 
        i.merge_rank = 1   
;