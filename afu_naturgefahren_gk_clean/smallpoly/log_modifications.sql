SELECT -- Ausgabe der Zusammenfassung der resultierenden Anzahl merges and "skips" von Kleinpolygonen
    operation,
    count(*) AS poly_count
FROM (
    SELECT 
        id, 
        CASE WHEN merge_big_id IS NOT NULL THEN 'Merged small polygons:' ELSE 'Skipped small polygons:' END AS operation
    FROM 
       public.poly_cleanup
    WHERE 
        is_small IS TRUE
)
GROUP BY 
    operation
;