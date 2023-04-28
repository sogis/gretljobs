--Flurnamen zuweisen
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
 WHERE
  vbg.mjpnl_version = 'MJPNL_2020'
;
