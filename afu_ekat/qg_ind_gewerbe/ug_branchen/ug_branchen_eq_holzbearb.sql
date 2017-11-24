 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN f.b10btot > 0 THEN ((( SELECT e.schast_efak
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.equelle_id = 184 AND e.s_code = 7 AND d.archive = 0 AND e.archive = 0)) * f.b10btot::numeric)::double precision
            ELSE 0::numeric::double precision
        END AS emiss_pm10
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT vz10_minus_sammel_ha.b10btot, 
            vz10_minus_sammel_ha.x_koord, vz10_minus_sammel_ha.y_koord
           FROM geostat.vz10_minus_sammel_ha) f ON a.xkoord = f.x_koord::numeric AND a.ykoord = f.y_koord::numeric
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
