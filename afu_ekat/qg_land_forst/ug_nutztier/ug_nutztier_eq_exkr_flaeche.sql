 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN b.emiss_ch4 IS NULL THEN 0::numeric
            ELSE round(b.emiss_ch4, 2)
        END AS emiss_ch4, 
        CASE
            WHEN b.emiss_pm10 IS NULL THEN 0::numeric
            ELSE round(b.emiss_pm10, 2)
        END AS emiss_pm10, 
        CASE
            WHEN b.emiss_nox IS NULL THEN 0::numeric
            ELSE round(b.emiss_nox, 2)
        END AS emiss_nox, 
        CASE
            WHEN b.emiss_n2o IS NULL THEN 0::numeric
            ELSE round(b.emiss_n2o, 2)
        END AS emiss_n2o, 
        CASE
            WHEN b.emiss_nh3 IS NULL THEN 0::numeric
            ELSE round(b.emiss_nh3::numeric, 2)
        END AS emiss_nh3
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT a.xkoord, a.ykoord, sum(a.emiss_ch4) AS emiss_ch4, 
            sum(a.emiss_pm10) AS emiss_pm10, sum(a.emiss_nox) AS emiss_nox, 
            sum(a.emiss_n2o) AS emiss_n2o, sum(a.emiss_nh3) AS emiss_nh3
           FROM ( SELECT a.pid, a.xkoord, a.ykoord, a.flaeche, 
                    a.flaeche * (m.emiss_ch4 / c.flaeche_betr) AS emiss_ch4, 
                    a.flaeche * (m.emiss_pm10 / c.flaeche_betr) AS emiss_pm10, 
                    a.flaeche * (m.emiss_nox / c.flaeche_betr) AS emiss_nox, 
                    a.flaeche * (w.emiss_n2o / c.flaeche_betr) AS emiss_n2o, 
                    a.flaeche::double precision * (aa.emiss_nh3 / c.flaeche_betr::double precision) AS emiss_nh3
                   FROM ( SELECT dyn_stdort_radien.pid, 
                            dyn_stdort_radien.xkoord, dyn_stdort_radien.ykoord, 
                            dyn_stdort_radien.flaeche
                           FROM ekat2015.dyn_stdort_radien) a
              LEFT JOIN ( SELECT dyn_stdort_radien.pid, 
                            sum(dyn_stdort_radien.flaeche) AS flaeche_betr
                           FROM ekat2015.dyn_stdort_radien
                          GROUP BY dyn_stdort_radien.pid) c ON a.pid = c.pid
         LEFT JOIN ( SELECT c.pid, 0.52 * c.emiss_ch4 AS emiss_ch4, 
                       0.52 * c.emiss_pm10 AS emiss_pm10, 
                       0.52 * c.emiss_nox AS emiss_nox
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
                              FROM ekat2015.dynamo_anz_tier) c) m ON a.pid = m.pid
    LEFT JOIN ( SELECT n.pid, 
                  0.52 * (n.anz_mk + n.anz_muku + n.anz_rv + n.anz_zuschw + n.anz_pfde + n.anz_schafe + n.anz_esel + n.anz_gflgl) * o.emiss_je_tier AS emiss_n2o, 
                  trunc(n.x_koord::numeric, (-2)) AS x_koord, 
                  trunc(n.y_koord::numeric, (-2)) AS y_koord
                 FROM ekat2015.dynamo_anz_tier n, 
                  ekat2015.dynamo_nutztiere_ch o) w ON a.pid = w.pid
   LEFT JOIN ( SELECT dynamo_nh3.pid, 
             trunc(dynamo_nh3.x_koord::numeric, (-2)) AS xkoord, 
             trunc(dynamo_nh3.y_koord::numeric, (-2)) AS ykoord, 
             coalesce(dynamo_nh3.nh3_emiss_flaeche,0) - coalesce(dynamo_nh3.pflanzenbau,0) - coalesce(dynamo_nh3.recycl_duenger,0) - coalesce(dynamo_nh3.hofduenger_transfer,0) AS emiss_nh3
            FROM ekat2015.dynamo_nh3
           ORDER BY dynamo_nh3.pid) aa ON a.pid = aa.pid) a
          GROUP BY a.xkoord, a.ykoord) b ON a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
