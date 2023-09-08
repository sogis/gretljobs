WITH 

erschliessungen_pro_gebauede_id AS (
    SELECT 
        jsonb_agg(e.bezeichnung) AS erschliessungen,
        ge.gebaeude_r AS gebauede_id
    FROM 
        agi_gebaeude_bsp_v1.erschliessung e 
    JOIN agi_gebaeude_bsp_v1.gebaeude__erschliessung ge ON e.t_id = ge.erschliessung_r 
    GROUP BY 
        ge.gebaeude_r
)

SELECT 
    g.bezeichnung,
    e.erschliessungen,
    g.umriss
FROM
    agi_gebaeude_bsp_v1.gebaeude g 
JOIN 
    erschliessungen_pro_gebauede_id e ON g.t_id = e.gebauede_id        
;