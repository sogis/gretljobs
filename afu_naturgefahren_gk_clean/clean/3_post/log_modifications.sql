SELECT -- Ausgabe der Zusammenfassung der resultierenden Anzahl merges and "skips" von Kleinpolygonen
    operation,
    count(*) AS poly_count
FROM (
    SELECT 
        id, 
        CASE WHEN parent_id IS NOT NULL THEN 'Merged small polygons:' ELSE 'Skipped small polygons:' END AS operation
    FROM 
       public.poly_cleanup
    WHERE 
        is_big IS FALSE
)
GROUP BY 
    operation
;