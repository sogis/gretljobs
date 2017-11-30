 SELECT c.ogc_fid, c.xkoord, c.ykoord, c.wkb_geometry, c.gem_bfs, 
        CASE
            WHEN d.waldart = 4 THEN (( SELECT quelle_emiss_efak.schast_efak
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 81 AND quelle_emiss_efak.s_code = 2 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))::real
            ELSE 0::real
        END AS emiss_nox, 
        CASE
            WHEN d.waldart = 4 THEN (( SELECT quelle_emiss_efak.schast_efak
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 81 AND quelle_emiss_efak.s_code = 22 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))::real
            ELSE 0::real
        END AS emiss_nmvoc, 
        CASE
            WHEN d.waldart = 4 THEN (( SELECT quelle_emiss_efak.schast_efak
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 81 AND quelle_emiss_efak.s_code = 6 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))::real
            ELSE 0::real
        END AS emiss_ch4, 
        CASE
            WHEN d.waldart = 4 THEN (( SELECT quelle_emiss_efak.schast_efak
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 81 AND quelle_emiss_efak.s_code = 26 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))::real
            ELSE 0::real
        END AS emiss_n2o
   FROM ekat2015.ha_raster_100 c
   LEFT JOIN ( SELECT wmg100.xkoord, wmg100.ykoord, wmg100.waldart, wmg100.fid, 
            wmg100.new_date, wmg100.archive_date, wmg100.archive
           FROM ekat2015.wmg100
          WHERE wmg100.archive = 0) d ON c.xkoord = d.xkoord::numeric AND c.ykoord = d.ykoord::numeric
  WHERE c.archive = 0
  ORDER BY c.xkoord, c.ykoord;
