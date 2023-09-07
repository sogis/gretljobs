WITH 

top_rrb AS (
    SELECT 
        ROW_NUMBER() OVER() AS rownum,
        rrb_nummer
    FROM 
        ada_archaeologie_v1.fachapplikation_regierungsratsbeschluss
    ORDER BY rrb_nummer
    LIMIT 10
),

top_fundstelle AS (
    SELECT 
        ROW_NUMBER() OVER() AS rownum,
        t_id AS fundstelle_tid
    FROM 
        ada_archaeologie_v1.fachapplikation_fundstelle
    ORDER BY fundstellen_nummer
    LIMIT 10    
),

rrb_fakerefs AS (
    SELECT 
        fundstelle_tid,
        rrb_nummer
    FROM 
        top_fundstelle f
    JOIN
        top_rrb r ON f.rownum = r.rownum
)

UPDATE 
    ada_archaeologie_v1.fachapplikation_fundstelle
SET 
    rrb_nummer = fr.rrb_nummer
FROM 
    rrb_fakerefs fr
WHERE 
    t_id = fundstelle_tid
;