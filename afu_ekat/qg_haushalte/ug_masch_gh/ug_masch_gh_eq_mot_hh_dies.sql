 SELECT c.ogc_fid, c.xkoord, c.ykoord, c.wkb_geometry, c.gem_bfs, 
        CASE
            WHEN g.art = 0 OR g.art = 11 THEN g.flaeche::double precision * (( SELECT quelle_emiss_efak.schast_emiss / e.anz_ha_ch::double precision * 1000::double precision * f.anz_ha_so::double precision / h.flaeche::double precision
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 6 AND quelle_emiss_efak.s_code = 5 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))
            ELSE 0::double precision
        END AS emiss_co, 
        CASE
            WHEN g.art = 0 OR g.art = 11 THEN g.flaeche::double precision * (( SELECT quelle_emiss_efak.schast_emiss / e.anz_ha_ch::double precision * 1000::double precision * f.anz_ha_so::double precision / h.flaeche::double precision
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 6 AND quelle_emiss_efak.s_code = 25 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))
            ELSE 0::double precision
        END AS emiss_co2, 
        CASE
            WHEN g.art = 0 OR g.art = 11 THEN g.flaeche::double precision * (( SELECT quelle_emiss_efak.schast_emiss / e.anz_ha_ch::double precision * 1000::double precision * f.anz_ha_so::double precision / h.flaeche::double precision
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 6 AND quelle_emiss_efak.s_code = 2 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))
            ELSE 0::double precision
        END AS emiss_nox, 
        CASE
            WHEN g.art = 0 OR g.art = 11 THEN g.flaeche::double precision * (( SELECT quelle_emiss_efak.schast_emiss / e.anz_ha_ch::double precision * 1000::double precision * f.anz_ha_so::double precision / h.flaeche::double precision
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 6 AND quelle_emiss_efak.s_code = 22 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))
            ELSE 0::double precision
        END AS emiss_nmvoc, 
        CASE
            WHEN g.art = 0 OR g.art = 11 THEN g.flaeche::double precision * (( SELECT quelle_emiss_efak.schast_emiss / e.anz_ha_ch::double precision * 1000::double precision * f.anz_ha_so::double precision / h.flaeche::double precision
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 6 AND quelle_emiss_efak.s_code = 7 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))
            ELSE 0::double precision
        END AS emiss_pm10, 
        CASE
            WHEN g.art = 0 OR g.art = 11 THEN g.flaeche::double precision * (( SELECT quelle_emiss_efak.schast_emiss / e.anz_ha_ch::double precision * 1000::double precision * f.anz_ha_so::double precision / h.flaeche::double precision
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 6 AND quelle_emiss_efak.s_code = 1 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))
            ELSE 0::double precision
        END AS emiss_so2, 
        CASE
            WHEN g.art = 0 OR g.art = 11 THEN g.flaeche::double precision * (( SELECT quelle_emiss_efak.schast_emiss / e.anz_ha_ch::double precision * 1000::double precision * f.anz_ha_so::double precision / h.flaeche::double precision
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 6 AND quelle_emiss_efak.s_code = 6 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))
            ELSE 0::double precision
        END AS emiss_ch4, 
        CASE
            WHEN g.art = 0 OR g.art = 11 THEN g.flaeche::double precision * (( SELECT quelle_emiss_efak.schast_emiss / e.anz_ha_ch::double precision * 1000::double precision * f.anz_ha_so::double precision / h.flaeche::double precision
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 6 AND quelle_emiss_efak.s_code = 8 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))
            ELSE 0::double precision
        END AS emiss_nh3, 
        CASE
            WHEN g.art = 0 OR g.art = 11 THEN g.flaeche::double precision * (( SELECT quelle_emiss_efak.schast_emiss / e.anz_ha_ch::double precision * 1000::double precision * f.anz_ha_so::double precision / h.flaeche::double precision
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 6 AND quelle_emiss_efak.s_code = 26 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0))
            ELSE 0::double precision
        END AS emiss_n2o
   FROM ekat2015.ha_raster_100 c
   LEFT JOIN ( SELECT min(intersec_bdbed_wohnzone_landw_ha_raster.art) AS art, 
            intersec_bdbed_wohnzone_landw_ha_raster.xkoord, 
            intersec_bdbed_wohnzone_landw_ha_raster.ykoord, 
            sum(intersec_bdbed_wohnzone_landw_ha_raster.flaeche) AS flaeche
           FROM ekat2015.intersec_bdbed_wohnzone_landw_ha_raster
          WHERE intersec_bdbed_wohnzone_landw_ha_raster.archive = 0 AND intersec_bdbed_wohnzone_landw_ha_raster.art = 0 OR intersec_bdbed_wohnzone_landw_ha_raster.art = 11
          GROUP BY intersec_bdbed_wohnzone_landw_ha_raster.xkoord, intersec_bdbed_wohnzone_landw_ha_raster.ykoord) g ON c.xkoord = g.xkoord::numeric AND c.ykoord = g.ykoord::numeric, 
    ( SELECT sum(asch92_sum.anz_ha_ch) AS anz_ha_ch
      FROM ekat2015.asch92_sum
     WHERE asch92_sum.nutzart >= 16 AND asch92_sum.nutzart <= 17 AND asch92_sum.archive = 0) e, 
    ( SELECT count(asch92.bn9725) AS anz_ha_so
      FROM ekat2015.asch92
     WHERE asch92.bn9725 >= 16 AND asch92.bn9725 <= 17 AND asch92.archive = 0) f, 
    ( SELECT sum(intersec_bdbed_wohnzone_landw_ha_raster.flaeche) AS flaeche
      FROM ekat2015.intersec_bdbed_wohnzone_landw_ha_raster
     WHERE intersec_bdbed_wohnzone_landw_ha_raster.archive = 0 AND intersec_bdbed_wohnzone_landw_ha_raster.art = 0 OR intersec_bdbed_wohnzone_landw_ha_raster.art = 11) h
  WHERE c.archive = 0
  ORDER BY c.xkoord, c.ykoord;
