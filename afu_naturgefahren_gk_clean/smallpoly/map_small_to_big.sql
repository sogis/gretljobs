/*
Klassiert die Polygone in grosse und kleine und füllt für Kleinpolygone
den Fremdschlüssel "merge_big_id" auf das zu mergende Grosspolygon aus.
*/


UPDATE -- Ergänzung aller Polygone unter der definierten Grösse mit Wert für den max. Durchmesser (max_diameter)
    public.poly_cleanup t
SET 
    g_max_diameter = max_diameter
FROM (
    SELECT 
        (ST_MaximumInscribedCircle(geom)).radius * 2 AS max_diameter,
        id
    FROM 
        public.poly_cleanup
    WHERE   
        g_area < ${clean_max_area}
) AS s
WHERE t.id = s.id
;

UPDATE -- Setzen von is_small für alle Polygone
    public.poly_cleanup t
SET 
    is_small = s.is_small 
FROM (
    SELECT 
        COALESCE(g_max_diameter, 999) < ${clean_max_diameter} AS is_small,
        id
    FROM 
        public.poly_cleanup  
) AS s
WHERE t.id = s.id
;

WITH 
intersecting AS ( 
    -- INTERSECT aller Kleinpolygone mit Grosspolygonen unter Berücksichtigung der zulässigen Gefahrenstufen-Unterschiede (Auflösen in kleinere Gefahrenstufe verboten).
    -- merge_rank ist klein bei kleinem Unterschied der Gefahrenstufen Kleinpolygon - Grosspolygon
    SELECT 
        small.id AS small_id,
        big.id AS big_id,
        big.hazard_level - small.hazard_level AS merge_level_diff,
        ROW_NUMBER() OVER (PARTITION BY small.id ORDER BY big.hazard_level - small.hazard_level ASC) AS merge_rank
    FROM 
    (
        SELECT 
            *
        FROM 
            public.poly_cleanup 
        WHERE
            is_small IS TRUE 
    ) AS small
    ,(
        SELECT 
            *
        FROM 
            public.poly_cleanup 
        WHERE
            is_small IS FALSE  
    ) AS big
    WHERE 
            ST_Intersects(small.geom,big.geom)
        AND 
            small.hazard_level <= big.hazard_level
)

UPDATE -- Aktualisierung der Kleinpolygon-Informationen mit der ID des Grosspolygons, auf welches gemergt wird.
    public.poly_cleanup t
SET 
    merge_big_id = i.big_id,
    merge_level_diff = i.merge_level_diff
FROM 
    intersecting i
WHERE 
        t.id = i.small_id
    AND 
        i.merge_rank = 1   
;