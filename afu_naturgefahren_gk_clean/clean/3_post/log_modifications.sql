SELECT -- Ausgabe der Zusammenfassung der resultierenden Anzahl merges and "skips" von Kleinpolygonen
    operation,
    count(*) AS poly_count
FROM (
    SELECT 
        id, 
        CASE 
            WHEN _is_big IS FALSE AND _parent_id_ref IS NOT NULL THEN 'Merged small polygons:'
            WHEN _is_big IS FALSE AND _parent_id_ref IS NULL THEN 'Skipped small polygons:' 
            WHEN _is_big IS TRUE AND _center_geom IS NOT NULL THEN 'Receiving big polygons:'
        END AS operation
    FROM 
       public.poly_cleanup
)
GROUP BY 
    operation
;