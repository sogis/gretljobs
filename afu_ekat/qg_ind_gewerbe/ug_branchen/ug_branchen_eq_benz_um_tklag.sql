 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN f.anz_arbpl > 0 THEN (( SELECT e.schast_emiss
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.equelle_id = 33 AND e.s_code = 25 AND d.archive = 0 AND e.archive = 0)) / c.ma_ch::double precision * 1000::double precision * f.anz_arbpl::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_co2, 
        CASE
            WHEN f.anz_arbpl > 0 THEN (( SELECT e.schast_emiss
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.equelle_id = 33 AND e.s_code = 22 AND d.archive = 0 AND e.archive = 0)) / c.ma_ch::double precision * 1000::double precision * f.anz_arbpl::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_nmvoc
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT sum(bz_noga_art_ha.anz_arbpl) AS anz_arbpl, 
            bz_noga_art_ha.xkoord, bz_noga_art_ha.ykoord
           FROM ekat2015.bz_noga_art_ha
          WHERE bz_noga_art_ha.noga_art = '467100'::text
          GROUP BY bz_noga_art_ha.xkoord, bz_noga_art_ha.ykoord) f ON a.xkoord = f.xkoord::numeric AND a.ykoord = f.ykoord::numeric, 
    ( SELECT sum(bz_noga_art_summe.ma_ch) AS ma_ch
      FROM ekat2015.bz_noga_art_summe
     WHERE bz_noga_art_summe.noga_art = '467100'::text) c
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
