 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN c.g15a01 > 0 THEN c.g15a01::numeric * (((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 127 AND b.s_code = 8 AND a.archive = 0 AND b.archive = 0))::numeric + (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 231 AND b.s_code = 8 AND a.archive = 0 AND b.archive = 0))::numeric) / (( SELECT sum(gz15_minus_sammel_ha.g15a01)
               FROM geostat.gz15_minus_sammel_ha
              WHERE gz15_minus_sammel_ha.archive = 0))::numeric * 1000::numeric)
            ELSE 0::numeric
        END AS emiss_nh3, 
        CASE
            WHEN c.g15a01 > 0 THEN c.g15a01::numeric * (((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 127 AND b.s_code = 22 AND a.archive = 0 AND b.archive = 0))::numeric + (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 231 AND b.s_code = 22 AND a.archive = 0 AND b.archive = 0))::numeric) / (( SELECT sum(gz15_minus_sammel_ha.g15a01)
               FROM geostat.gz15_minus_sammel_ha
              WHERE gz15_minus_sammel_ha.archive = 0))::numeric * 1000::numeric)
            ELSE 0::numeric
        END AS emiss_nmvoc
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT gz15_minus_sammel_ha.x_koord, 
            gz15_minus_sammel_ha.y_koord, gz15_minus_sammel_ha.g15a01
           FROM geostat.gz15_minus_sammel_ha
          WHERE gz15_minus_sammel_ha.archive = 0) c ON a.xkoord = c.x_koord::numeric AND a.ykoord = c.y_koord::numeric
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
