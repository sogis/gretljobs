SELECT -- Ausgabe der Zusammenfassung der resultierenden Anzahl merges and "skips" von Kleinpolygonen
    operation,
    count(*) AS poly_count
FROM (
    SELECT 
        id, 
        CASE WHEN _parent_id_ref IS NOT NULL THEN 'Merged small polygons:' ELSE 'Skipped small polygons:' END AS operation
    FROM 
       public.poly_cleanup
    WHERE 
        _is_big IS FALSE
)
GROUP BY 
    operation
;