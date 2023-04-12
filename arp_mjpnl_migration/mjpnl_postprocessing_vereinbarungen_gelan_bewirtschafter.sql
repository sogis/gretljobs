--GELAN Bewirtschaftungseinheit zuweisen
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
  vbg.gelan_pid_gelan = 9999999 AND vbg.gelan_bewe_id != '9999999'
;
