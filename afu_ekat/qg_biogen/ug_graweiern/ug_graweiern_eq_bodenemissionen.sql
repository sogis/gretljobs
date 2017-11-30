 SELECT c.ogc_fid, c.xkoord, c.ykoord, c.wkb_geometry, c.gem_bfs, 
        CASE
            WHEN d.art = 14 OR d.art = 15 THEN (d.flaeche::double precision * ((( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.quelle_emiss_efak
              WHERE quelle_emiss_efak.equelle_id = 173 AND quelle_emiss_efak.s_code = 22 AND quelle_emiss_efak.archive = 0)) * 1000::double precision / g.ha_asch::double precision))::numeric
            ELSE 0::numeric
        END AS emiss_nmvoc
   FROM ekat2015.ha_raster_100 c
   LEFT JOIN ( SELECT min(intersec_bdbed_ha_raster.art) AS art, 
            intersec_bdbed_ha_raster.xkoord, intersec_bdbed_ha_raster.ykoord, 
            sum(intersec_bdbed_ha_raster.flaeche) AS flaeche
           FROM ekat2015.intersec_bdbed_ha_raster
          WHERE intersec_bdbed_ha_raster.archive = 0 AND intersec_bdbed_ha_raster.art = 14 OR intersec_bdbed_ha_raster.art = 15
          GROUP BY intersec_bdbed_ha_raster.xkoord, intersec_bdbed_ha_raster.ykoord) d ON c.xkoord = d.xkoord::numeric AND c.ykoord = d.ykoord::numeric, 
    ( SELECT sum(asch92_sum.anz_ha_ch) AS ha_asch
      FROM ekat2015.asch92_sum
     WHERE asch92_sum.nutzart >= 5 AND asch92_sum.nutzart <= 9) g
  WHERE c.archive = 0
  ORDER BY c.xkoord, c.ykoord;
