-- Erstellt "künstlich" die Gebietsverknüpfungen für alle publizierten Themenbereitstellungen
WITH 

publ_themepubs AS (
    SELECT 
        id AS tp_id,
        coverage_ident AS tp_cov_ident
    FROM
        simi.simitheme_theme_publication
    WHERE 
            public_model_name IS NOT NULL
        AND 
            coverage_ident IS NOT NULL
),

publ_subareas AS (
    SELECT 
        id AS area_id,
        tp_id
    FROM
        simi.simitheme_sub_area s
    JOIN
        publ_themepubs t ON s.coverage_ident = t.tp_cov_ident    
)


INSERT INTO 
    simi.simitheme_published_sub_area(
        id, 
        update_ts, 
        create_ts, 
        created_by, 
        "version", 
        published, 
        prev_published, 
        sub_area_id, 
        theme_publication_id
    )
SELECT 
    gen_random_uuid() AS id,
    now() AS update_ts,
    now() AS create_ts,
    'admin' AS created_by,
    1 AS "version",
    now() AS published,
    now() AS prev_published,
    area_id AS sub_area_id,
    tp_id AS theme_publication_id
FROM 
    publ_subareas
;