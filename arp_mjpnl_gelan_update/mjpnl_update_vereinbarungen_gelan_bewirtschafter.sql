--Setze zuerst von denen, die wechseln werden, den Status bewe_id_geprueft auf false
--Aufgrund von organischem Wachstum heisst die Spalte bewe_id_geprueft, betrifft aber die pid_gelan und nicht die bewe_id
UPDATE ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
  SET bewe_id_geprueft = false
  WHERE 
    ST_IsValid(vbg.geometrie) = TRUE 
    AND
    vbg.gelan_pid_gelan NOT IN (
      SELECT
        p.pid_gelan
      FROM
        ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit bw
        LEFT JOIN ${DB_Schema_MJPNL}.betrbsdttrktrdten_betrieb b ON bw.betrieb = b.t_id
        LEFT JOIN ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person p ON b.person = p.t_id
      WHERE
        bewe_id = vbg.gelan_bewe_id
      LIMIT 1
    )
    AND
    vbg.uebersteuerung_bewirtschafter IS FALSE
    AND
    -- nur wenn aktuelles Datum nicht zwischen dem 1. Dezember und dem 15. Januar liegt
    (date_part('month',now()) NOT IN (1,12) OR (date_part('month',now())=1 AND date_part('day',now())>15))
;

--GELAN Person aus Bewirtschaftungseinheit zuweisen
UPDATE
   ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
     SET gelan_pid_gelan=(
       COALESCE(
        (SELECT
         p.pid_gelan
        FROM
           ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit bw
           LEFT JOIN ${DB_Schema_MJPNL}.betrbsdttrktrdten_betrieb b ON bw.betrieb = b.t_id
           LEFT JOIN ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person p ON b.person = p.t_id
         WHERE
           bewe_id = vbg.gelan_bewe_id
		    ),9999999)
     )
 WHERE
  vbg.uebersteuerung_bewirtschafter IS FALSE
  AND
  -- nur wenn aktuelles Datum nicht zwischen dem 1. Dezember und dem 15. Januar liegt
  (date_part('month',now()) NOT IN (1,12) OR (date_part('month',now())=1 AND date_part('day',now())>15))
;
