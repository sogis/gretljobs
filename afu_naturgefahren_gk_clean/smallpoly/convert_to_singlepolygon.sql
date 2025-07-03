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

,mapped AS (
    SELECT 
        i.id,
        m.l_int AS hazard_level,
        i.geometrie
    FROM 
        public.interface_table i
    JOIN 
        hazard_level_map m ON i.gefahrenstufe = m.l_string
)

,exploded AS (
    SELECT 
        (ST_Dump(geometrie)).geom AS singlepoly,
        id AS multipoly_id,
        hazard_level
    FROM 
        mapped 
)

INSERT INTO
    public.poly_cleanup(
        id,
        multipoly_id,
        singlepoly,        
        g_area,
        hazard_level
    )
SELECT
    ROW_NUMBER() OVER() AS id,
    multipoly_id,
    singlepoly,
    ST_Area(singlepoly) AS g_area,
    hazard_level
FROM 
    exploded
;