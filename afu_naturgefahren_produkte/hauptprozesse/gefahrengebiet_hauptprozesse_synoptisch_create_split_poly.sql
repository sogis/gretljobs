WITH
lines AS (
    SELECT   
        ST_Union(ST_Boundary(geometrie)) as geometrie
    FROM
        gk_poly
)

,splited AS (
  SELECT 
    (ST_Dump(ST_Polygonize(geometrie))).geom AS geometrie
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