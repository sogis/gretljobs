 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN b.flaeche > 0::numeric THEN (( SELECT e.schast_emiss
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.equelle_id = 119 AND e.s_code = 22 AND d.archive = 0 AND e.archive = 0)) / c.ma_ch::double precision * e.ma_kt::double precision / d.flaeche_kt::double precision * 1000::double precision * b.flaeche::double precision
            ELSE 0::numeric::double precision
        END AS emiss_nmvoc
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT intersec_bdbed_ha_raster.xkoord, 
            intersec_bdbed_ha_raster.ykoord, 
            sum(intersec_bdbed_ha_raster.flaeche) AS flaeche
           FROM ekat2015.intersec_bdbed_ha_raster
          WHERE intersec_bdbed_ha_raster.art = ANY (ARRAY[1, 2, 3, 6, 9, 11, 12])
          GROUP BY intersec_bdbed_ha_raster.xkoord, intersec_bdbed_ha_raster.ykoord) b ON a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric, 
    ( SELECT sum(intersec_bdbed_ha_raster.flaeche) AS flaeche_kt
      FROM ekat2015.intersec_bdbed_ha_raster
     WHERE intersec_bdbed_ha_raster.art = ANY (ARRAY[1, 2, 3, 6, 9, 11, 12])) d, 
    ( SELECT sum(bz_noga_art_summe.ma_kt) AS ma_kt
      FROM ekat2015.bz_noga_art_summe
     WHERE bz_noga_art_summe.noga_art = '421100'::text) e, 
    ( SELECT sum(bz_noga_art_summe.ma_ch) AS ma_ch
      FROM ekat2015.bz_noga_art_summe
     WHERE bz_noga_art_summe.noga_art = '421100'::text) c
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
