--Liegenschaften zuweisen
UPDATE
   ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vbg
     SET 
      gb_nr=(
        SELECT
         COALESCE(array_agg(gs.nummer ORDER BY gs.nummer),'{"unbekannt"}') AS gb_nr
        FROM
           agi_dm01avso24.liegenschaften_liegenschaft ls
           LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck gs
                ON gs.t_datasetname::integer = ANY (vbg.bfs_nr)
                   AND gs.t_id = ls.liegenschaft_von
        WHERE
          ls.t_datasetname::integer = ANY (vbg.bfs_nr)
           AND ST_Intersects(ls.geometrie,vbg.geometrie)
     )
WHERE
  vbg.mjpnl_version = 'MJPNL_2020'
;
