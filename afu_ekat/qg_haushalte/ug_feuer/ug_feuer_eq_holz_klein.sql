 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN g.g15a01 > 0 THEN g.g15a01::double precision * (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 126 AND b.s_code = 5 AND a.archive = 0 AND b.archive = 0)) / (( SELECT sum(gz15_minus_sammel_ha.g15a01) FROM geostat.gz15_minus_sammel_ha WHERE gz15_minus_sammel_ha.archive = 0))::numeric::double precision * 1000::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_co, 
        CASE
            WHEN g.g15a01 > 0 THEN g.g15a01::double precision * (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 126 AND b.s_code = 25 AND a.archive = 0 AND b.archive = 0)) / (( SELECT sum(gz15_minus_sammel_ha.g15a01) FROM geostat.gz15_minus_sammel_ha WHERE gz15_minus_sammel_ha.archive = 0))::numeric::double precision * 1000::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_co2, 
        CASE
            WHEN g.g15a01 > 0 THEN g.g15a01::double precision * (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 126 AND b.s_code = 2 AND a.archive = 0 AND b.archive = 0)) / (( SELECT sum(gz15_minus_sammel_ha.g15a01) FROM geostat.gz15_minus_sammel_ha WHERE gz15_minus_sammel_ha.archive = 0))::numeric::double precision * 1000::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_nox, 
        CASE
            WHEN g.g15a01 > 0 THEN g.g15a01::double precision * (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 126 AND b.s_code = 1 AND a.archive = 0 AND b.archive = 0)) / (( SELECT sum(gz15_minus_sammel_ha.g15a01) FROM geostat.gz15_minus_sammel_ha WHERE gz15_minus_sammel_ha.archive = 0))::numeric::double precision * 1000::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_so2, 
        CASE
            WHEN g.g15a01 > 0 THEN g.g15a01::double precision * (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 126 AND b.s_code = 7 AND a.archive = 0 AND b.archive = 0)) / (( SELECT sum(gz15_minus_sammel_ha.g15a01) FROM geostat.gz15_minus_sammel_ha WHERE gz15_minus_sammel_ha.archive = 0))::numeric::double precision * 1000::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_pm10, 
        CASE
            WHEN g.g15a01 > 0 THEN g.g15a01::double precision * (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 126 AND b.s_code = 6 AND a.archive = 0 AND b.archive = 0)) / (( SELECT sum(gz15_minus_sammel_ha.g15a01) FROM geostat.gz15_minus_sammel_ha WHERE gz15_minus_sammel_ha.archive = 0))::numeric::double precision * 1000::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_ch4, 
        CASE
            WHEN g.g15a01 > 0 THEN g.g15a01::double precision * (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 126 AND b.s_code = 22 AND a.archive = 0 AND b.archive = 0)) / (( SELECT sum(gz15_minus_sammel_ha.g15a01) FROM geostat.gz15_minus_sammel_ha WHERE gz15_minus_sammel_ha.archive = 0))::numeric::double precision * 1000::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_nmvoc, 
        CASE
            WHEN g.g15a01 > 0 THEN g.g15a01::double precision * (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 126 AND b.s_code = 8 AND a.archive = 0 AND b.archive = 0)) / (( SELECT sum(gz15_minus_sammel_ha.g15a01) FROM geostat.gz15_minus_sammel_ha WHERE gz15_minus_sammel_ha.archive = 0))::numeric::double precision * 1000::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_nh3, 
        CASE
            WHEN g.g15a01 > 0 THEN g.g15a01::double precision * (( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 126 AND b.s_code = 26 AND a.archive = 0 AND b.archive = 0)) / (( SELECT sum(gz15_minus_sammel_ha.g15a01) FROM geostat.gz15_minus_sammel_ha WHERE gz15_minus_sammel_ha.archive = 0))::numeric::double precision * 1000::numeric::double precision
            ELSE 0::numeric::double precision
        END AS emiss_n2o
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT gz15_minus_sammel_ha.x_koord, 
            gz15_minus_sammel_ha.y_koord, gz15_minus_sammel_ha.g15a01
           FROM geostat.gz15_minus_sammel_ha
          WHERE gz15_minus_sammel_ha.archive = 0) g ON a.xkoord = g.x_koord::numeric AND a.ykoord = g.y_koord::numeric
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
