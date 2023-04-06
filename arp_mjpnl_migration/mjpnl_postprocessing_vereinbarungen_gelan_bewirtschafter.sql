--GELAN Bewirtschaftungseinheit zuweisen
UPDATE
   arp_mjpnl_v1.mjpnl_vereinbarung AS vbg
     SET gelan_pid_gelan=(
       COALESCE(
        (SELECT
         p.pid_gelan
        FROM
           arp_mjpnl_v1.betrbsdttrktrdten_bewirtschaftungseinheit bw
           LEFT JOIN arp_mjpnl_v1.betrbsdttrktrdten_betrieb b ON bw.betrieb = b.t_id
           LEFT JOIN arp_mjpnl_v1.betrbsdttrktrdten_gelan_person p ON b.person = p.t_id
         WHERE
           bewe_id = vbg.gelan_bewe_id
		),9999999)
     )
 WHERE
  vbg.gelan_pid_gelan = 9999999 AND vbg.gelan_bewe_id != '9999999'
;
