--GELAN Bewirtschaftungseinheit zuweisen
UPDATE
   ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
     SET gelan_bewe_id=(
       COALESCE(
        (SELECT
         bw.bewe_id
        FROM
           ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit bw
         WHERE
            ST_Intersects(vbg.geometrie, bw.geometrie)     
            ORDER BY ST_Area(ST_Intersection(vbg.geometrie, bw.geometrie)) DESC
            LIMIT 1
        ),'9999999')
     )
;