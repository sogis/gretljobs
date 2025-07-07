WITH 

hazard_level_map AS ( -- Zuordnung der gefahrenstufen auf Ganzzahlen. Grössere Gefährdung = grössere Zahl.
    SELECT
        varchar AS l_string,
        int AS l_int
    FROM ( VALUES
        ('nicht_gefaehrdet', 0),
        ('restgefaehrdung', 10),
        ('gering', 20),
        ('mittel', 30),
        ('erheblich', 40)
    ) AS t(varchar, int) 
)

UPDATE 
    public.poly_cleanup t
SET 
    _hazard_level = coalesce(l_int, -999999) -- -999999 ist für int2 OUT OF RANGE -> wirft Fehler  
FROM 
    public.poly_cleanup p 
LEFT JOIN 
    hazard_level_map m ON p.gefahrenstufe = m.l_string 
WHERE 
    t.id = p.id
;