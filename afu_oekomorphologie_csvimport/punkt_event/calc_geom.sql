SET search_path TO ${dbSchema};

WITH 

fraction_measure_raw AS (
  SELECT 
    c.metergnrso / public.st_length(g.geometrie) AS m,
    c.t_id AS csv_tid,
    g.t_id AS base_tid
  FROM 
    ${eventTable} c
  JOIN
    gewaesserbasisgeometrie g ON c.rgewaesser = g.t_id 
),

fraction_measure AS (
  SELECT 
    CASE
      WHEN m < 0 THEN 0
      WHEN m > 1 THEN 1
      ELSE m
    END AS m,
    csv_tid,
    base_tid
  FROM 
    fraction_measure_raw 
),

point AS (
  SELECT
    public.ST_LineInterpolatePoint(g.geometrie, m) AS geom,
    csv_tid,
    base_tid
  FROM
    fraction_measure m
  JOIN
    gewaesserbasisgeometrie g ON m.base_tid = g.t_id 
)

UPDATE
  ${eventTable}
SET
  punktberechnet = geom
FROM
  point p
WHERE
  t_id = p.csv_tid
;
