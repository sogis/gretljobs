 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN f.b15btot > 0 THEN (( SELECT e.schast_emiss
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.q_code = 133 AND e.s_code = 5 AND d.archive = 0 AND e.archive = 0)) / c.b15btot_ch::double precision * f.b15btot::double precision * 1000::double precision
            ELSE 0::numeric::double precision
        END AS emiss_co, 
        CASE
            WHEN f.b15btot > 0 THEN (( SELECT e.schast_emiss
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.q_code = 133 AND e.s_code = 25 AND d.archive = 0 AND e.archive = 0)) / c.b15btot_ch::double precision * f.b15btot::double precision * 1000::double precision
            ELSE 0::numeric::double precision
        END AS emiss_co2, 
        CASE
            WHEN f.b15btot > 0 THEN (( SELECT e.schast_emiss
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.q_code = 133 AND e.s_code = 2 AND d.archive = 0 AND e.archive = 0)) / c.b15btot_ch::double precision * f.b15btot::double precision * 1000::double precision
            ELSE 0::numeric::double precision
        END AS emiss_nox, 
        CASE
            WHEN f.b15btot > 0 THEN (( SELECT e.schast_emiss
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.q_code = 133 AND e.s_code = 1 AND d.archive = 0 AND e.archive = 0)) / c.b15btot_ch::double precision * f.b15btot::double precision * 1000::double precision
            ELSE 0::numeric::double precision
        END AS emiss_so2, 
        CASE
            WHEN f.b15btot > 0 THEN (( SELECT e.schast_emiss
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.q_code = 133 AND e.s_code = 7 AND d.archive = 0 AND e.archive = 0)) / c.b15btot_ch::double precision * f.b15btot::double precision * 1000::double precision
            ELSE 0::numeric::double precision
        END AS emiss_pm10
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT vz15_minus_sammel_ha.b15btot, 
            vz15_minus_sammel_ha.x_koord, vz15_minus_sammel_ha.y_koord
           FROM geostat.vz15_minus_sammel_ha
          WHERE vz15_minus_sammel_ha.archive = 0) f ON a.xkoord = f.x_koord::numeric AND a.ykoord = f.y_koord::numeric, 
    ( SELECT sum(vz15_minus_sammel_ha.b15btot) AS b15btot_ch FROM geostat.vz15_minus_sammel_ha WHERE vz15_minus_sammel_ha.archive = 0) c
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
