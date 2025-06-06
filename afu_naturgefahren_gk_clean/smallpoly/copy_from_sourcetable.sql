/*
Kopiert die Polygone von der entsprechenden GK in die Tabelle "poly_cleanup"
*/

DELETE FROM 
    public.poly_cleanup
;

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

INSERT INTO -- Insert aus Quelle in Verarbeitungstabelle
    public.poly_cleanup(
        id,
        hazard_level,
        g_area,
        geom
    )
    SELECT
        t_id AS id,
        COALESCE(l_int, -99) AS hazard_level,
        ST_Area(geometrie) AS g_area,
        geometrie AS geom
    FROM 
        ${sourcetable} p
    LEFT JOIN 
        hazard_level_map m ON p.gefahrenstufe = m.l_string 
    --LIMIT 1000
;