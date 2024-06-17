with

lines as (
  select 
    st_union(st_boundary(geometrie)) as geometrie
  from
    gk_poly
)

,splited AS (
  SELECT 
    (st_dump(st_polygonize(geometrie))).geom AS geometrie
  FROM
    lines
)

,withpoint as (
    select
        ROW_NUMBER() OVER() as id, 
        geometrie as poly,
        ST_PointOnSurface(geometrie) as point
    from 
        splited
)

insert into splited(id, point, poly)
select id, point, poly from withpoint
;