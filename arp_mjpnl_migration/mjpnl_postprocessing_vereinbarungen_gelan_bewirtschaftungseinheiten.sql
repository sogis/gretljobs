--GELAN Bewirtschaftungseinheit zuweisen
UPDATE
   arp_mjpnl_v1.mjpnl_vereinbarung AS vbg
     SET gelan_bewe_id=(
       COALESCE(
        (SELECT
         bw.bewe_id
        FROM
           arp_mjpnl_v1.betrbsdttrktrdten_bewirtschaftungseinheit bw
         WHERE
           ST_Within(ST_PointOnSurface(vbg.geometrie),bw.geometrie)
        ),'9999999')
     )
 WHERE
  vbg.gelan_bewe_id = '9999999'
;
