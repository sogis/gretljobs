WITH rrb_with_oerebgeom AS (
    SELECT 
        r.t_id AS rrb_tid
    FROM
        ada_archaeologie_v1.fachapplikation_regierungsratsbeschluss r
    JOIN 
        ada_archaeologie_v1.fachapplikation_fundstelle f ON r.t_id = f.rrb_role  
    JOIN
        ada_archaeologie_v1.geo_flaeche g ON f.t_id = g.fundstelle_role
    WHERE 
        g.oereb_flaeche IS TRUE
    GROUP BY 
        r.t_id
),

orphan_rrb AS (
    SELECT 
        r.t_id AS rrb_tid
    FROM 
        ada_archaeologie_v1.fachapplikation_regierungsratsbeschluss r
    LEFT JOIN 
        rrb_with_oerebgeom o ON r.t_id = o.rrb_tid
    WHERE 
        o.rrb_tid IS NULL
)

UPDATE 
    ada_archaeologie_v1.fachapplikation_fundstelle f
SET 
    rrb_role = NULL    
FROM 
    orphan_rrb r
WHERE 
    f.rrb_role = r.rrb_tid        
;
