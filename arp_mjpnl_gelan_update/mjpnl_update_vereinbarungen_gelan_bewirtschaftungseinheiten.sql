--Setze zuerst von denen, die wechseln werden, den Status bewe_id_geprueft auf false
UPDATE ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
  SET bewe_id_geprueft = false
  WHERE 
    ST_IsValid(vbg.geometrie) = TRUE 
    AND
    vbg.gelan_bewe_id NOT IN (
      SELECT
        bw.bewe_id
      FROM
        ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit bw
      WHERE
        ST_Intersects(vbg.geometrie, bw.geometrie)     
      ORDER BY ST_Area(ST_Intersection(vbg.geometrie, bw.geometrie)) DESC
      LIMIT 1
    )
    AND
    -- nur wenn aktuelles Datum nicht zwischen dem 1. Dezember und dem 15. Januar liegt
    (date_part('month',now()) NOT IN (1,12) OR (date_part('month',now())=1 AND date_part('day',now())>15))
;

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
  -- nur wenn aktuelles Datum nicht zwischen dem 1. Dezember und dem 15. Januar liegt
  (date_part('month',now()) NOT IN (1,12) OR (date_part('month',now())=1 AND date_part('day',now())>15))
;
