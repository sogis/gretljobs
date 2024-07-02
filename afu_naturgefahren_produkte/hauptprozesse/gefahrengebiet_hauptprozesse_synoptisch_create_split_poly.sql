WITH
lines AS (
    SELECT   
        st_union(st_boundary(geometrie)) as geometrie
    FROM
        gk_poly
)

,splited AS (
  SELECT 
    (st_dump(st_polygonize(geometrie))).geom AS geometrie
  FROM
    lines
)

,withpoint AS (
    SELECT
        ROW_NUMBER() OVER() as id, 
        geometrie as poly,
        ST_PointOnSurface(geometrie) as point
    FROM 
        splited
)

INSERT INTO 
    splited(
        id, 
        point, 
        poly
    )
SELECT 
    id, 
    point, 
    poly 
FROM 
    withpoint
;