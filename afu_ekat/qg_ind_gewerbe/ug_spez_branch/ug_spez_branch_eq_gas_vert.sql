(SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN b.g15e05 > 0 AND d.g15e05_gem > 0 THEN b.g15e05::double precision * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 5 AND b.s_code = 22 AND a.archive = 0 AND b.archive = 0)) / (( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.quelle_emiss_efak
              WHERE quelle_emiss_efak.equelle_id = 235 AND quelle_emiss_efak.s_code = 22 AND quelle_emiss_efak.archive = 0)) * c.erdgasverbrauch::double precision / d.g15e05_gem::double precision) * 1000::double precision
            ELSE 0::numeric::double precision
        END AS emiss_nmvoc, 
        CASE
            WHEN b.g15e05 > 0 AND d.g15e05_gem > 0 THEN b.g15e05::double precision * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 5 AND b.s_code = 6 AND a.archive = 0 AND b.archive = 0)) / (( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.quelle_emiss_efak
              WHERE quelle_emiss_efak.equelle_id = 235 AND quelle_emiss_efak.s_code = 6 AND quelle_emiss_efak.archive = 0)) * c.erdgasverbrauch::double precision / d.g15e05_gem::double precision) * 1000::double precision
            ELSE 0::numeric::double precision
        END AS emiss_ch4, 
        CASE
            WHEN b.g15e05 > 0 AND d.g15e05_gem > 0 THEN b.g15e05::double precision * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 5 AND b.s_code = 25 AND a.archive = 0 AND b.archive = 0)) / (( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.quelle_emiss_efak
              WHERE quelle_emiss_efak.equelle_id = 235 AND quelle_emiss_efak.s_code = 25 AND quelle_emiss_efak.archive = 0)) * c.erdgasverbrauch::double precision / d.g15e05_gem::double precision) * 1000::double precision
            ELSE 0::numeric::double precision
        END AS emiss_co2
   FROM (SELECT * FROM ekat2015.ha_raster_100 WHERE ST_Disjoint(wkb_geometry,(SELECT wkb_geometry FROM ekat2015.stahlwerk_gerlafingen))) a -- Alle Kacheln ausser Stahlwerk Gerlafingen 
   LEFT JOIN ( SELECT 
                CASE
                    WHEN sum(b.g15e05) IS NOT NULL THEN sum(b.g15e05)
                    ELSE 0::bigint
                END AS g15e05_gem, 
            a.gem_bfs
           FROM (SELECT * FROM ekat2015.ha_raster_100 WHERE ST_Disjoint(wkb_geometry,(SELECT wkb_geometry FROM ekat2015.stahlwerk_gerlafingen))) a -- Alle Kacheln ausser Stahlwerk Gerlafingen 
      LEFT JOIN geostat.gz15_minus_sammel_ha b ON a.xkoord = b.x_koord::numeric AND a.ykoord = b.y_koord::numeric
     GROUP BY a.gem_bfs) d ON a.gem_bfs = d.gem_bfs
   LEFT JOIN ( SELECT gz15_minus_sammel_ha.g15e05, gz15_minus_sammel_ha.x_koord, 
       gz15_minus_sammel_ha.y_koord
      FROM geostat.gz15_minus_sammel_ha) b ON a.xkoord = b.x_koord::numeric AND a.ykoord = b.y_koord::numeric
   LEFT JOIN ( SELECT gmde.gem_bfs, gmde.erdgasverbrauch
   FROM ekat2015.gmde
  WHERE gmde.archive = 0) c ON a.gem_bfs = c.gem_bfs
  ORDER BY a.xkoord, a.ykoord)

  UNION ALL 

-- Extraberechnungen für das Stahlwerk. Der Wert 33'539'822 stammt aus der Tabelle ds_10 (Gasverbrauch). 0.025, weil es 40 Kacheln sind (1/40) 

(SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
       0.025 * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 5 AND b.s_code = 22 AND a.archive = 0 AND b.archive = 0)) / (( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.quelle_emiss_efak
              WHERE quelle_emiss_efak.equelle_id = 235 AND quelle_emiss_efak.s_code = 22 AND quelle_emiss_efak.archive = 0)) * 33539822) * 1000::double precision
        AS emiss_nmvoc, 
       0.025 * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 5 AND b.s_code = 6 AND a.archive = 0 AND b.archive = 0)) / (( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.quelle_emiss_efak
              WHERE quelle_emiss_efak.equelle_id = 235 AND quelle_emiss_efak.s_code = 6 AND quelle_emiss_efak.archive = 0)) * 33539822) * 1000::double precision
        AS emiss_ch4, 
        0.025 * ((( SELECT b.schast_emiss
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE a.equelle_id = 5 AND b.s_code = 25 AND a.archive = 0 AND b.archive = 0)) / (( SELECT quelle_emiss_efak.schast_emiss
               FROM ekat2015.quelle_emiss_efak
              WHERE quelle_emiss_efak.equelle_id = 235 AND quelle_emiss_efak.s_code = 25 AND quelle_emiss_efak.archive = 0)) * 33539822) * 1000::double precision
        AS emiss_co2
   FROM (SELECT * FROM ekat2015.ha_raster_100 WHERE ST_Intersects(wkb_geometry,(SELECT wkb_geometry FROM ekat2015.stahlwerk_gerlafingen))) a -- Kacheln des Stahlwerkes Gerlafingen
   LEFT JOIN ( SELECT 
                CASE
                    WHEN sum(b.g15e05) IS NOT NULL THEN sum(b.g15e05)
                    ELSE 0::bigint
                END AS g15e05_gem, 
            a.gem_bfs
           FROM (SELECT * FROM ekat2015.ha_raster_100 WHERE ST_Intersects(wkb_geometry,(SELECT wkb_geometry FROM ekat2015.stahlwerk_gerlafingen))) a -- Kacheln des Stahlwerkes Gerlafingen
      LEFT JOIN geostat.gz15_minus_sammel_ha b ON a.xkoord = b.x_koord::numeric AND a.ykoord = b.y_koord::numeric
     GROUP BY a.gem_bfs) d ON a.gem_bfs = d.gem_bfs
   LEFT JOIN ( SELECT gz15_minus_sammel_ha.g15e05, gz15_minus_sammel_ha.x_koord, 
       gz15_minus_sammel_ha.y_koord
      FROM geostat.gz15_minus_sammel_ha) b ON a.xkoord = b.x_koord::numeric AND a.ykoord = b.y_koord::numeric
  ORDER BY a.xkoord, a.ykoord);
    
