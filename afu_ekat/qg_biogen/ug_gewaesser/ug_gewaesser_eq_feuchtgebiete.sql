 SELECT c.ogc_fid, c.xkoord, c.ykoord, c.wkb_geometry, c.gem_bfs, 
        CASE
            WHEN d.art = 23 OR d.art = 27 THEN (( SELECT quelle_emiss_efak.schast_efak
               FROM ekat2015.quelle_emiss_efak
              WHERE quelle_emiss_efak.equelle_id = 70 AND quelle_emiss_efak.s_code = 2 AND quelle_emiss_efak.archive = 0)) * d.flaeche
            ELSE 0::numeric
        END AS emiss_nox, 
        CASE
            WHEN d.art = 23 OR d.art = 27 THEN (( SELECT quelle_emiss_efak.schast_efak
               FROM ekat2015.quelle_emiss_efak
              WHERE quelle_emiss_efak.equelle_id = 70 AND quelle_emiss_efak.s_code = 6 AND quelle_emiss_efak.archive = 0)) * d.flaeche
            ELSE 0::numeric
        END AS emiss_ch4, 
        CASE
            WHEN d.art = 23 OR d.art = 27 THEN (( SELECT quelle_emiss_efak.schast_efak
               FROM ekat2015.quelle_emiss_efak
              WHERE quelle_emiss_efak.equelle_id = 70 AND quelle_emiss_efak.s_code = 26 AND quelle_emiss_efak.archive = 0)) * d.flaeche
            ELSE 0::numeric
        END AS emiss_n2o
   FROM ekat2015.ha_raster_100 c
   LEFT JOIN ( SELECT min(intersec_bdbed_ha_raster.art) AS art, 
            intersec_bdbed_ha_raster.xkoord, intersec_bdbed_ha_raster.ykoord, 
            sum(intersec_bdbed_ha_raster.flaeche) AS flaeche
           FROM ekat2015.intersec_bdbed_ha_raster
          WHERE intersec_bdbed_ha_raster.archive = 0 AND intersec_bdbed_ha_raster.art = 23 OR intersec_bdbed_ha_raster.art = 27
          GROUP BY intersec_bdbed_ha_raster.xkoord, intersec_bdbed_ha_raster.ykoord) d ON c.xkoord = d.xkoord::numeric AND c.ykoord = d.ykoord::numeric
  WHERE c.archive = 0
  ORDER BY c.xkoord, c.ykoord;
