WITH fst_num_join AS (
    SELECT 
        g.t_id AS geo_tid,
        COALESCE (f.t_id, -1) AS attr_tid -- Setzen von -1, damit die ILI-Validierung bei nicht übereinstimmender Fst-Nummer fehlschlägt
    FROM
        ada_archaeologie_v1.geo_flaeche g
    LEFT JOIN 
        ada_archaeologie_v1.fachapplikation_fundstelle f ON f.fundstellen_nummer = g.fundstellen_nummer
)

UPDATE 
    ada_archaeologie_v1.geo_flaeche g
SET 
    fundstelle_role = attr_tid
FROM 
    fst_num_join j
WHERE 
    g.t_id = j.geo_tid
;