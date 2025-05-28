WITH 

small_center AS (
    SELECT 
        merge_big_id AS big_id,
        ST_PointOnSurface(geom) AS centerpoint
    FROM
        afu_schutzbauten_v1.tmp_polygon 
    WHERE 
        merge_big_id IS NOT NULL 
)

,big_center_id AS (
    SELECT 
        merge_big_id
    FROM 
        afu_schutzbauten_v1.tmp_polygon 
    GROUP BY
        merge_big_id
)

,big_center AS (
    SELECT 
        id AS big_id,
        ST_PointOnSurface(geom) AS centerpoint
    FROM
        afu_schutzbauten_v1.tmp_polygon p
    JOIN
        big_center_id c ON p.id = c.merge_big_id
)

,big_centermarker AS (
    SELECT 
        big_id,        
        (ST_DumpPoints(
            ST_Buffer(
                centerpoint,
                0.25,
                1
            )        
        )).geom AS centerpoint 
    FROM 
        big_center
)

SELECT
    big_id,
    ST_COLLECT(centerpoint) AS mpoint
FROM (
    SELECT big_id, centerpoint FROM small_center
    UNION ALL 
    SELECT big_id, centerpoint FROM big_center
    UNION ALL 
    SELECT big_id, centerpoint FROM big_centermarker
) c
GROUP BY 
    big_id

