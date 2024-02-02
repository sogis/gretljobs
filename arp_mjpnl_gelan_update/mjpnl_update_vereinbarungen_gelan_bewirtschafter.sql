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
