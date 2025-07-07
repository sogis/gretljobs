SELECT -- Ausgabe der Zusammenfassung der resultierenden Anzahl merges von Kleinpolygonen
    operation,
    count(*) AS poly_count
FROM (
    SELECT 
        id, 
        CASE 
            WHEN out_small_clean_result = 'complete' THEN 'Fully merged small polygons:' 
            WHEN out_small_clean_result = 'partial' THEN 'Partially merged small polygons:' 
            WHEN out_small_clean_result = 'not_cleaned' THEN 'Not merged (= skipped) small polygons:' 
            ELSE '!ERROR! - Unhandled clean result' END AS operation
    FROM 
        public.interface_table
    WHERE 
        out_small_clean_result IS NOT NULL
)
GROUP BY 
    operation
;