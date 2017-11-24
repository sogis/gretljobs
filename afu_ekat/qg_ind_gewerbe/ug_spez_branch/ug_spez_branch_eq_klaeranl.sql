 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN b.xkoord IS NOT NULL THEN b.einw_gleich_wert::numeric * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 1 AND b.s_code = 5 AND a.archive = 0 AND b.archive = 0))::numeric / e.b10tot_ch::numeric * 1000::numeric * d.b10tot_so::numeric) / c.einw_gleich_wert_so::numeric
            ELSE 0::numeric
        END AS emiss_co, 
        CASE
            WHEN b.xkoord IS NOT NULL THEN b.einw_gleich_wert::numeric * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 1 AND b.s_code = 2 AND a.archive = 0 AND b.archive = 0))::numeric / e.b10tot_ch::numeric * 1000::numeric * d.b10tot_so::numeric) / c.einw_gleich_wert_so::numeric
            ELSE 0::numeric
        END AS emiss_nox, 
        CASE
            WHEN b.xkoord IS NOT NULL THEN b.einw_gleich_wert::numeric * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 1 AND b.s_code = 1 AND a.archive = 0 AND b.archive = 0))::numeric / e.b10tot_ch::numeric * 1000::numeric * d.b10tot_so::numeric) / c.einw_gleich_wert_so::numeric
            ELSE 0::numeric
        END AS emiss_so2, 
        CASE
            WHEN b.xkoord IS NOT NULL THEN b.einw_gleich_wert::numeric * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 1 AND b.s_code = 22 AND a.archive = 0 AND b.archive = 0))::numeric / e.b10tot_ch::numeric * 1000::numeric * d.b10tot_so::numeric) / c.einw_gleich_wert_so::numeric
            ELSE 0::numeric
        END AS emiss_nmvoc, 
        CASE
            WHEN b.xkoord IS NOT NULL THEN b.einw_gleich_wert::numeric * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 1 AND b.s_code = 6 AND a.archive = 0 AND b.archive = 0))::numeric / e.b10tot_ch::numeric * 1000::numeric * d.b10tot_so::numeric) / c.einw_gleich_wert_so::numeric
            ELSE 0::numeric
        END AS emiss_ch4, 
        CASE
            WHEN b.xkoord IS NOT NULL THEN b.einw_gleich_wert::numeric * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 1 AND b.s_code = 8 AND a.archive = 0 AND b.archive = 0))::numeric / e.b10tot_ch::numeric * 1000::numeric * d.b10tot_so::numeric) / c.einw_gleich_wert_so::numeric
            ELSE 0::numeric
        END AS emiss_nh3, 
        CASE
            WHEN b.xkoord IS NOT NULL THEN b.einw_gleich_wert::numeric * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 1 AND b.s_code = 26 AND a.archive = 0 AND b.archive = 0))::numeric / e.b10tot_ch::numeric * 1000::numeric * d.b10tot_so::numeric) / c.einw_gleich_wert_so::numeric
            ELSE 0::numeric
        END AS emiss_n2o
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT klaeranlagen.fid, klaeranlagen.ort, klaeranlagen.xkoord, 
            klaeranlagen.ykoord, klaeranlagen.einw_gleich_wert
           FROM ekat2015.klaeranlagen) b ON a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric, 
    ( SELECT sum(klaeranlagen.einw_gleich_wert) AS einw_gleich_wert_so
      FROM ekat2015.klaeranlagen) c, 
    ( SELECT sum(b.b10btot) AS b10tot_so
      FROM ekat2015.ha_raster_100 a
   LEFT JOIN geostat.vz10_minus_sammel_ha b ON a.xkoord = b.x_koord::numeric AND a.ykoord = b.y_koord::numeric) d, 
    ( SELECT vz10_minus_sammel_ha.b10btot AS b10tot_ch
      FROM geostat.vz10_minus_sammel_ha
     WHERE vz10_minus_sammel_ha.archive = 0 AND vz10_minus_sammel_ha.x_koord = (-1)) e
  ORDER BY a.xkoord, a.ykoord;
