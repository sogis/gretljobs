 SELECT c.ogc_fid, c.xkoord, c.ykoord, c.wkb_geometry, c.gem_bfs, 
        CASE
            WHEN d.b15btot > 0 THEN d.b15btot::double precision * ((( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 169 AND quelle_emiss_efak.s_code = 7 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0)) / e.b15btot_ch::double precision) * 1000::double precision
            ELSE 0::real::double precision
        END AS emiss_pm10, 
        CASE
            WHEN d.b15btot > 0 THEN d.b15btot::double precision * ((( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 169 AND quelle_emiss_efak.s_code = 22 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0)) / e.b15btot_ch::double precision) * 1000::double precision
            ELSE 0::real::double precision
        END AS emiss_nmvoc, 
        CASE
            WHEN d.b15btot > 0 THEN d.b15btot::double precision * ((( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 169 AND quelle_emiss_efak.s_code = 8 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0)) / e.b15btot_ch::double precision) * 1000::double precision
            ELSE 0::real::double precision
        END AS emiss_nh3, 
        CASE
            WHEN d.b15btot > 0 THEN d.b15btot::double precision * ((( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.emiss_quelle, ekat2015.quelle_emiss_efak
              WHERE emiss_quelle.equelle_id = 169 AND quelle_emiss_efak.s_code = 25 AND emiss_quelle.equelle_id = quelle_emiss_efak.equelle_id AND emiss_quelle.archive = 0 AND quelle_emiss_efak.archive = 0)) / e.b15btot_ch::double precision) * 1000::double precision
            ELSE 0::real::double precision
        END AS emiss_co2
   FROM ekat2015.ha_raster_100 c
   LEFT JOIN geostat.vz15_minus_sammel_ha d ON c.xkoord = d.x_koord::numeric AND c.ykoord = d.y_koord::numeric, 
    ( SELECT sum(vz15_minus_sammel_ha.b15btot) AS b15btot_ch FROM geostat.vz15_minus_sammel_ha) e
  WHERE c.archive = 0
  ORDER BY c.xkoord, c.ykoord;
