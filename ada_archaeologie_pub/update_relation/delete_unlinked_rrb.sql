WITH unlinked_rrb AS (
    SELECT 
        r.t_id AS rrb_tid
    FROM
        ada_archaeologie_v1.fachapplikation_regierungsratsbeschluss r
    LEFT JOIN 
        ada_archaeologie_v1.fachapplikation_fundstelle f ON r.t_id = f.rrb_role  
    WHERE 
        f.rrb_role IS NULL
)

DELETE FROM 
    ada_archaeologie_v1.fachapplikation_regierungsratsbeschluss r
USING 
    unlinked_rrb u
WHERE 
    r.t_id = u.rrb_tid
;