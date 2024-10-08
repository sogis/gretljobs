--GELAN Bewirtschaftungseinheit zuweisen
UPDATE
   ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
     SET gelan_bewe_id=(
       COALESCE(
        ( SELECT 
            bw.bewe_id
          FROM
            ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit bw
          WHERE
            ST_Intersects(vbg.geometrie, bw.geometrie)     
          ORDER BY ST_Area(ST_Intersection(vbg.geometrie, bw.geometrie)) DESC
          LIMIT 1
        )
        ,'9999999')
     )
 WHERE
  ST_IsValid(vbg.geometrie) = TRUE
  AND 
  -- ändere keine inaktive vereinbarungen
  vbg.status_vereinbarung != 'inaktiv'
  AND
  -- nur wenn aktuelles Datum nicht zwischen dem 1. Dezember und dem 15. Januar liegt
  (date_part('month',now()) NOT IN (1,12) OR (date_part('month',now())=1 AND date_part('day',now())>15))
  AND
  -- nur wenn die gelan tabelle nicht leer ist
  (SELECT COUNT(*) FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit )>0
;
