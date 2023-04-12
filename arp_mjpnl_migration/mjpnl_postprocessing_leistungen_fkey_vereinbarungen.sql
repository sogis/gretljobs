-- Foreign key zwischen einzelner Leistung und Vereinbarung herstellen
UPDATE
  ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstgorig
   SET vereinbarung = COALESCE(vbg.t_id,9999999)
FROM
   ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung lstg
   LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
     ON vbg.flaechen_id_alt = (split_part(lstg.bemerkung,'§',2)::jsonb -> 'polyid')::int4
WHERE 
  lstgorig.t_id = lstg.t_id
  AND lstgorig.vereinbarung = 9999999
  AND strpos(lstgorig.bemerkung,'§') > 0
  AND vbg.t_id IS NOT NULL
;
