--Flurnamen und Liegenschaften zuweisen
UPDATE
   ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
	 SET flurname=(
        SELECT
		 COALESCE(array_agg(fn.aname),'{"unbekannt"}') AS flurname
		FROM
		   agi_dm01avso24.nomenklatur_flurname fn
		 WHERE
		     fn.t_datasetname::integer = ANY (vbg.bfs_nr) 
		   AND
		     (
			   ST_Intersects(fn.geometrie,vbg.geometrie)
		        AND
		       (ST_MaximumInscribedCircle(ST_Intersection(fn.geometrie,vbg.geometrie))).radius > 1
			 )
	 )
	 /* deaktiviert - Memory-Probleme */
	 /*,
	  gb_nr=(
        SELECT
		 COALESCE(array_agg(gs.nummer),'{"unbekannt"}') AS gb_nr
		FROM
		   agi_dm01avso24.liegenschaften_liegenschaft ls, agi_dm01avso24.liegenschaften_grundstueck gs
		 WHERE
		  ls.t_datasetname::integer = ANY (vbg.bfs_nr)
		  AND gs.t_datasetname::integer = ANY (vbg.bfs_nr)
		  AND gs.t_id = ls.liegenschaft_von
		  AND 
		  (
		    ST_Intersects(ls.geometrie,vbg.geometrie)
		     AND
		    (ST_MaximumInscribedCircle(ST_Intersection(ls.geometrie,vbg.geometrie))).radius > 1
          )
	 )*/
 WHERE
  vbg.mjpnl_version = 'MJPNL_2020'
;
