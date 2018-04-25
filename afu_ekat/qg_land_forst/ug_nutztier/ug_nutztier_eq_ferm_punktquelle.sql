SELECT m.pid, a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN a.xkoord = m.x_koord AND a.ykoord = m.y_koord THEN 0.48 * m.emiss_ch4
            ELSE 0::numeric
        END AS emiss_ch4
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT min(c.pid) AS pid, c.x_koord, c.y_koord, 
            sum(c.emiss_ch4) AS emiss_ch4
           FROM ( SELECT dynamo_anz_tier.pid, 
                    dynamo_anz_tier.anz_mk * (( SELECT d.schast_efak
                           FROM ekat2015.quelle_emiss_efak d, 
                            ekat2015.emiss_quelle e
                          WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 16 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_muku * (( SELECT d.schast_efak
                           FROM ekat2015.quelle_emiss_efak d, 
                            ekat2015.emiss_quelle e
                          WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 198 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_rv * (( SELECT d.schast_efak
                           FROM ekat2015.quelle_emiss_efak d, 
                            ekat2015.emiss_quelle e
                          WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 194 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_zuschw * (( SELECT d.schast_efak
                           FROM ekat2015.quelle_emiss_efak d, 
                            ekat2015.emiss_quelle e
                          WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 23 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_pfde * (( SELECT d.schast_efak
                           FROM ekat2015.quelle_emiss_efak d, 
                            ekat2015.emiss_quelle e
                          WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 26 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_esel * (( SELECT d.schast_efak
                           FROM ekat2015.quelle_emiss_efak d, 
                            ekat2015.emiss_quelle e
                          WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 27 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_ziegen * (( SELECT d.schast_efak
                           FROM ekat2015.quelle_emiss_efak d, 
                            ekat2015.emiss_quelle e
                          WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 22 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_schafe * (( SELECT d.schast_efak
                           FROM ekat2015.quelle_emiss_efak d, 
                            ekat2015.emiss_quelle e
                          WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 20 AND d.archive = 0 AND e.archive = 0)) + dynamo_anz_tier.anz_gflgl * (( SELECT d.schast_efak
                           FROM ekat2015.quelle_emiss_efak d, 
                            ekat2015.emiss_quelle e
                          WHERE e.equelle_id = d.equelle_id AND d.s_code = 6 AND e.equelle_id = 192 AND d.archive = 0 AND e.archive = 0)) AS emiss_ch4, 
                    trunc(dynamo_anz_tier.x_koord::numeric, (-2)) AS x_koord, 
                    trunc(dynamo_anz_tier.y_koord::numeric, (-2)) AS y_koord
                   FROM ekat2015.dynamo_anz_tier) c
          GROUP BY c.x_koord, c.y_koord) m ON a.xkoord = m.x_koord AND a.ykoord = m.y_koord
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
