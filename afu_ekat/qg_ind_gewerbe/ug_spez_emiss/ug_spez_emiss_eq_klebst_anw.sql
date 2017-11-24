 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN f.anz_arbpl > 0 THEN (( SELECT e.schast_emiss
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.equelle_id = 116 AND e.s_code = 22 AND d.archive = 0 AND e.archive = 0)) / b.ma_ch::double precision * f.anz_arbpl::numeric::double precision * 1000::double precision
            ELSE 0::numeric::double precision
        END AS emiss_nmvoc
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT sum(bz_noga_art_ha.anz_arbpl) AS anz_arbpl, 
            bz_noga_art_ha.xkoord, bz_noga_art_ha.ykoord
           FROM ekat2015.bz_noga_art_ha
          WHERE (bz_noga_art_ha.noga_art = ANY (ARRAY['181400'::text, '433200'::text, '433301'::text, '433302'::text, '433303'::text, '952300'::text, '952400'::text])) OR (substr(bz_noga_art_ha.noga_art, 1, 2) = ANY (ARRAY['15'::text, '26'::text, '29'::text, '30'::text, '31'::text, '32'::text, '33'::text]))
          GROUP BY bz_noga_art_ha.xkoord, bz_noga_art_ha.ykoord) f ON a.xkoord = f.xkoord::numeric AND a.ykoord = f.ykoord::numeric, 
    ( SELECT sum(bz_noga_art_summe.ma_ch) AS ma_ch
      FROM ekat2015.bz_noga_art_summe
     WHERE (bz_noga_art_summe.noga_art = ANY (ARRAY['181400'::text, '433200'::text, '433301'::text, '433302'::text, '433303'::text, '952300'::text, '952400'::text])) OR (substr(bz_noga_art_summe.noga_art, 1, 2) = ANY (ARRAY['15'::text, '26'::text, '29'::text, '30'::text, '31'::text, '32'::text, '33'::text]))) b
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
