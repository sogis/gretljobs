/*
Wählt von den Multipart-Gemeinden den Ring mit der grössten Fläche und gibt 
diesen als "Singlepart-Zwilling" zurück.
Grund: Zielmodell ist als Singlepolygon definiert.
*/
WITH 

poly_parts AS (
  SELECT 
    (ST_Dump(geometrie)).geom AS singlepoly,
    t_id
  FROM 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze  
),

poly_parts_area AS (
  SELECT 
    poly_parts.*,
    (ST_Area(singlepoly) * 100)::int8 AS area_key
  FROM 
    poly_parts
),

max_area_per_tid AS (
  SELECT 
    max(area_key) AS max_area_key,
    t_id
  FROM 
    poly_parts_area
  GROUP BY 
    t_id
),

gem_singlepoly as (
	SELECT 
		singlepoly,
		a.t_id
	FROM
		poly_parts_area a
	JOIN
		max_area_per_tid m on a.area_key = m.max_area_key
)

SELECT 
  t_ili_tid,
  ${tid}::integer AS rdatenabdeckung,
  singlepoly AS apolygon,
  bfs_gemeindenummer::varchar AS identifier,
  gemeindename AS bezeichnung
FROM 
  agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gem
JOIN
  gem_singlepoly geo on gem.t_id = geo.t_id
;