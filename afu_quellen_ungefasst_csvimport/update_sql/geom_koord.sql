WITH 

geom AS (
  SELECT
    st_transform(
      st_point(
        x_koordinate_lv03, 
        y_koordinate_lv03,
        21781
      ),
      2056
    ) AS punkt_geom,
    t_id
  FROM 
    afu_quellen_ungefasst_staging_v1.csv_import
),

geom_koord AS (
  SELECT 
    g.*,
    round(ST_X(g.punkt_geom)) AS x_koord,
    round(ST_Y(g.punkt_geom)) AS y_koord
  FROM 
    geom g
)

UPDATE 
  afu_quellen_ungefasst_staging_v1.csv_import
SET 
  punkt = punkt_geom,
  x_koordinate = x_koord,
  y_koordinate = y_koord
FROM 
  geom_koord
WHERE 
  csv_import.t_id = geom_koord.t_id
;