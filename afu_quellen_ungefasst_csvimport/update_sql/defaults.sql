WITH 

def_vals AS (
  SELECT 
    COALESCE(schuettungsverhalten, 'ganzjährig') AS schuettungsverhalten,
    COALESCE(vernetzung, 'Einzelquelle') AS vernetzung,
    COALESCE(austrittsanzahl, 1) AS austrittsanzahl,
    COALESCE(substrate, '!ERR!') AS substrate,
    current_date AS importdatum,
    t_id
  FROM 
    afu_quellen_ungefasst_staging_v1.csv_import
)

UPDATE 
  afu_quellen_ungefasst_staging_v1.csv_import
SET 
  schuettungsverhalten = d.schuettungsverhalten,
  vernetzung = d.vernetzung,
  austrittsanzahl = d.austrittsanzahl,
  importdatum = d.importdatum,
  substrate = d.substrate
FROM 
  def_vals d
WHERE 
  csv_import.t_id = d.t_id
;