--diverse spatial joins:
--Gemeinden, GS-Nummern, Flurnamen
UPDATE
   arp_mjpnl_v1.mjpnl_vereinbarung AS vbg
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
	 )/*,
	 gb_nr=(
        SELECT
		 COALESCE(array_agg(gs.nummer),'{"unbekannt"}') AS gb_nr
		FROM
		   agi_dm01avso24.liegenschaften_liegenschaft ls, agi_dm01avso24.liegenschaften_grundstueck gs
		 WHERE
		   ST_Intersects(ls.geometrie,vbg.geometrie)
		   AND
		   (ST_MaximumInscribedCircle(ST_Intersection(ls.geometrie,vbg.geometrie))).radius > 1
		   AND gs.t_id = ls.liegenschaft_von
	 )*/
 WHERE
  vbg.mjpnl_version = 'MJPNL_2020'
;
  
