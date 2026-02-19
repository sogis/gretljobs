WITH classified AS (
    SELECT
        CASE
            WHEN decibel < 50 THEN 'eins'
            WHEN decibel >= 50 AND decibel < 60 THEN 'zwei'
            WHEN decibel >= 60 AND decibel < 70 THEN 'drei'
            WHEN decibel >= 70 THEN 'vier'
        END AS db_class,
        pixel_quadrat
    FROM 
        afu_schiesslaerm_v1.schiesslaerm_import
),
dissolved AS (
    SELECT
        db_class,
        ST_UnaryUnion(
            ST_Collect(pixel_quadrat)
        ) AS geom
    FROM 
        classified
    GROUP BY 
        db_class
),
anlage AS (
    SELECT 
        a.id,
        bezeichnung
    FROM 
        afu_schiesslaerm_v1.anlage_attribute a
    JOIN
        afu_schiesslaerm_v1.anlage_kandidat k ON a.id = k.id
),
joined AS (
    SELECT
        db_class,
        id,
        bezeichnung,
        geom
    FROM 
        dissolved, anlage
),
single_parts AS (
    SELECT
        db_class,
        id,
        bezeichnung,
        (ST_Dump(geom)).geom::geometry(Polygon, 2056) AS geom
    FROM 
        joined
)

INSERT INTO 
    afu_schiesslaerm_stage_v1.schiesslaerm (
        empfindlichkeitsstufe,
        anlage_id,
        anlage_bezeichnung,
        flaeche
    )
SELECT
    db_class,
    id,
    bezeichnung,
    geom
FROM 
    single_parts
;