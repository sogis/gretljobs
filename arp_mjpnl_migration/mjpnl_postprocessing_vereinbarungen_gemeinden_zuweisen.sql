--Gemeinden zuweisen: BFS-NR und Gemeindenamen
UPDATE
   ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
     SET bfs_nr=(
        SELECT
		 COALESCE(array_agg(gg.bfs_gemeindenummer),'{9999}') AS bfs_nr
		FROM
		   agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gg
		 WHERE
		   ST_Intersects(gg.geometrie,vbg.geometrie)
		   AND
		   (ST_MaximumInscribedCircle(ST_Intersection(gg.geometrie,vbg.geometrie))).radius > 1
	 ),
	 gemeinde=(
        SELECT
		 COALESCE(array_agg(gg.gemeindename),'{"unbekannt"}') AS gemeinde
		FROM
		   agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gg
		 WHERE
		   ST_Intersects(gg.geometrie,vbg.geometrie)
		   AND
		   (ST_MaximumInscribedCircle(ST_Intersection(gg.geometrie,vbg.geometrie))).radius > 1
	 )
 WHERE
  vbg.mjpnl_version = 'MJPNL_2020'
;
