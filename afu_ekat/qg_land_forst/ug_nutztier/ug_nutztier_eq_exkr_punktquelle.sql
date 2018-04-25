SELECT m.pid, a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN a.xkoord = aa.xkoord AND a.ykoord = aa.ykoord THEN aa.emiss_nh3
            ELSE 0::double precision
        END AS emiss_nh3, 
        CASE
            WHEN a.xkoord = m.x_koord AND a.ykoord = m.y_koord THEN 0.48 * m.emiss_pm10
            ELSE 0::numeric
        END AS emiss_pm10, 
        CASE
            WHEN a.xkoord = m.x_koord AND a.ykoord = m.y_koord THEN 0.48 * m.emiss_nox
            ELSE 0::numeric
        END AS emiss_nox, 
        CASE
            WHEN a.xkoord = m.x_koord AND a.ykoord = m.y_koord THEN 0.48 * m.emiss_ch4
            ELSE 0::numeric
        END AS emiss_ch4, 
        CASE
            WHEN a.xkoord = w.x_koord AND a.ykoord = w.y_koord THEN 0.48 * w.emiss_n2o
            ELSE 0::numeric
        END AS emiss_n2o
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT min(dynamo_nh3.pid) AS pid, 
            trunc(dynamo_nh3.x_koord::numeric, (-2)) AS xkoord, 
            trunc(dynamo_nh3.y_koord::numeric, (-2)) AS ykoord, 
            sum(dynamo_nh3.nh3_emiss_punkt) AS emiss_nh3
           FROM ekat2015.dynamo_nh3
          GROUP BY trunc(dynamo_nh3.x_koord::numeric, (-2)), trunc(dynamo_nh3.y_koord::numeric, (-2))) aa ON a.xkoord = aa.xkoord AND a.ykoord = aa.ykoord
   LEFT JOIN ( SELECT min(c.pid) AS pid, c.x_koord, c.y_koord, 
       sum(c.emiss_ch4) AS emiss_ch4, sum(c.emiss_pm10) AS emiss_pm10, 
       sum(c.emiss_nox) AS emiss_nox
      FROM ( SELECT dynamo_anz_tier.pid, 
               dynamo_anz_tier.anz_mk * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 17 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_muku * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 199 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_rv * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 195 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_zuschw * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 24 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_pfde * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 201 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_esel * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 28 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_ziegen * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 32 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_schafe * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 21 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_gflgl * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 193 AND d.archive = 0 AND e.archive = 0)) AS emiss_ch4, 
               dynamo_anz_tier.anz_mk * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 7 AND e.equelle_id = 17 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_muku * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 7 AND e.equelle_id = 199 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_rv * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 7 AND e.equelle_id = 195 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_zuschw * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 7 AND e.equelle_id = 24 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_pfde * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 7 AND e.equelle_id = 201 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_esel * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 7 AND e.equelle_id = 28 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_ziegen * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 7 AND e.equelle_id = 32 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_schafe * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 7 AND e.equelle_id = 21 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_gflgl * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 7 AND e.equelle_id = 193 AND d.archive = 0 AND e.archive = 0)) AS emiss_pm10, 
               dynamo_anz_tier.anz_mk * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 2 AND e.equelle_id = 17 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_muku * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 2 AND e.equelle_id = 199 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_rv * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 2 AND e.equelle_id = 195 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_zuschw * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 2 AND e.equelle_id = 24 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_pfde * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 2 AND e.equelle_id = 201 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_esel * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 2 AND e.equelle_id = 28 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_ziegen * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 2 AND e.equelle_id = 32 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_schafe * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 2 AND e.equelle_id = 21 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_gflgl * (( SELECT d.schast_efak
                      FROM ekat2015.quelle_emiss_efak d, 
                       ekat2015.emiss_quelle e
                     WHERE e.equelle_id = d.equelle_id AND d.s_code = 2 AND e.equelle_id = 193 AND d.archive = 0 AND e.archive = 0)) AS emiss_nox, 
               trunc(dynamo_anz_tier.x_koord::numeric, (-2)) AS x_koord, 
               trunc(dynamo_anz_tier.y_koord::numeric, (-2)) AS y_koord
              FROM ekat2015.dynamo_anz_tier) c
     GROUP BY c.x_koord, c.y_koord) m ON a.xkoord = m.x_koord AND a.ykoord = m.y_koord
   LEFT JOIN ( SELECT v.x_koord, v.y_koord, sum(v.emiss_n2o) AS emiss_n2o
   FROM ( SELECT n.pid, 
            (n.anz_mk + n.anz_muku + n.anz_rv + n.anz_zuschw + n.anz_pfde + n.anz_schafe + n.anz_esel + n.anz_gflgl) * o.emiss_je_tier AS emiss_n2o, 
            trunc(n.x_koord::numeric, (-2)) AS x_koord, 
            trunc(n.y_koord::numeric, (-2)) AS y_koord
           FROM ekat2015.dynamo_anz_tier n, ekat2015.dynamo_nutztiere_ch o) v
  GROUP BY v.x_koord, v.y_koord) w ON a.xkoord = w.x_koord AND a.ykoord = w.y_koord
  ORDER BY a.xkoord, a.ykoord;
