SET search_path TO ${dbSchema};

WITH 

fraction_measures_raw AS (
  SELECT 
    c.vongnrso / public.st_length(g.geometrie) AS m_von,
    c.bisgnrso / public.st_length(g.geometrie) AS m_bis,
    c.t_id AS csv_tid,
    g.t_id AS base_tid
  FROM 
    ${eventTable} c
  JOIN
    gewaesserbasisgeometrie g ON c.rgewaesser = g.t_id 
),

fraction_measures AS (
  SELECT 
    CASE
      WHEN m_von < 0 THEN 0
      WHEN m_von > 1 THEN 1
      ELSE m_von
    END AS m_von,
    CASE
      WHEN m_bis < 0 THEN 0
      WHEN m_bis > 1 THEN 1
      ELSE m_bis
    END AS m_bis,
    csv_tid,
    base_tid
  FROM 
    fraction_measures_raw 
),

linepoints AS (
  SELECT
    public.ST_LineInterpolatePoint(g.geometrie, m_von) AS p_von,
    public.ST_LineInterpolatePoint(g.geometrie, (m_von + m_bis)/2) AS p_mitte,
    public.ST_LineInterpolatePoint(g.geometrie, m_bis) AS p_bis,
    csv_tid,
    base_tid
  FROM
    fraction_measures m
  JOIN
    gewaesserbasisgeometrie g ON m.base_tid = g.t_id 
),

linegeom AS (
  SELECT
    public.ST_MakeLine(ARRAY[p_von, p_mitte, p_bis]) AS geom,
    csv_tid
  FROM
    linepoints
)

UPDATE
  ${eventTable}
SET
  linieberechnet = geom
FROM
  linegeom l
WHERE
  t_id = l.csv_tid
;
