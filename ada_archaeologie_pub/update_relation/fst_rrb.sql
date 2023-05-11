WITH rrb_num_join AS (
    SELECT 
        f.t_id AS fst_tid,
        COALESCE (r.t_id, -1) AS rrb_tid -- Setzen von -1, damit die ILI-Validierung bei nicht übereinstimmender RRB-Nummer fehlschlägt
    FROM
        ada_archaeologie_v1.fachapplikation_fundstelle f
    LEFT JOIN 
        ada_archaeologie_v1.fachapplikation_regierungsratsbeschluss r ON f.rrb_nummer = r.rrb_nummer 
    WHERE
        f.rrb_nummer IS NOT NULL
)

UPDATE 
    ada_archaeologie_v1.fachapplikation_fundstelle f
SET 
    rrb_role = rrb_tid
FROM 
    rrb_num_join j
WHERE 
    f.t_id = j.fst_tid
;