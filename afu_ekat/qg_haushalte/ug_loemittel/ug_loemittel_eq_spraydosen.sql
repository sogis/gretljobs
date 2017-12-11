 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN f.b15btot > 0 THEN (( SELECT e.schast_efak
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.equelle_id = 112 AND e.s_code = 22 AND d.archive = 0 AND e.archive = 0)) * f.b15btot::numeric
            ELSE 0::numeric
        END AS emiss_nmvoc
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT vz15_minus_sammel_ha.b15btot, 
            vz15_minus_sammel_ha.x_koord, vz15_minus_sammel_ha.y_koord
           FROM geostat.vz15_minus_sammel_ha
          WHERE vz15_minus_sammel_ha.archive = 0) f ON a.xkoord = f.x_koord::numeric AND a.ykoord = f.y_koord::numeric
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
