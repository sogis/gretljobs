--Setze zuerst von denen, die wechseln werden, den Status bewe_id_geprueft auf false
UPDATE ${DB_Schema_MJPNL}.mjpnl_vereinbarung
SET bewe_id_geprueft = false
WHERE t_id IN (
SELECT
  vbg.t_id
FROM
	${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
JOIN
    ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit bw
  ON
    ST_Within(ST_PointOnSurface(vbg.geometrie),bw.geometrie)
WHERE 
  vbg.gelan_bewe_id != bw.bewe_id
);

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
           ST_Within(ST_PointOnSurface(vbg.geometrie),bw.geometrie)
        ),'9999999')
     )
;
