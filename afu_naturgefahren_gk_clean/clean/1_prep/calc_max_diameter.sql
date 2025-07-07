UPDATE -- Ergänzung aller Polygone unter der definierten Grösse mit Wert für den max. Durchmesser (max_diameter)
    public.poly_cleanup t
SET 
    g_max_diameter = max_diameter
FROM (
    SELECT 
        (ST_MaximumInscribedCircle(singlepoly)).radius * 2 AS max_diameter,
        id
    FROM 
        public.poly_cleanup
    WHERE   
        g_area < ${clean_max_area}
) AS s
WHERE t.id = s.id
;