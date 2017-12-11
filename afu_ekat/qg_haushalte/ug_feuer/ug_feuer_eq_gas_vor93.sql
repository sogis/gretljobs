 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN c.g15e05 > 0 THEN c.g15e05::double precision * ((d.anteil_feuer_gas_aelter93 / 100::numeric * (d.anteil_feuer_gas / 100::numeric))::double precision * d.energieverbr * (( SELECT b.schast_efak
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 67 AND b.s_code = 5 AND a.archive = 0 AND b.archive = 0))::double precision / f.sum_a00e05::double precision)
            ELSE 0::real::double precision
        END AS emiss_co, 
        CASE
            WHEN c.g15e05 > 0 THEN c.g15e05::double precision * ((d.anteil_feuer_gas_aelter93 / 100::numeric * (d.anteil_feuer_gas / 100::numeric))::double precision * d.energieverbr * (( SELECT b.schast_efak
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 67 AND b.s_code = 25 AND a.archive = 0 AND b.archive = 0))::double precision / f.sum_a00e05::double precision)
            ELSE 0::real::double precision
        END AS emiss_co2, 
        CASE
            WHEN c.g15e05 > 0 THEN c.g15e05::double precision * ((d.anteil_feuer_gas_aelter93 / 100::numeric * (d.anteil_feuer_gas / 100::numeric))::double precision * d.energieverbr * (( SELECT b.schast_efak
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 67 AND b.s_code = 2 AND a.archive = 0 AND b.archive = 0))::double precision / f.sum_a00e05::double precision)
            ELSE 0::real::double precision
        END AS emiss_nox, 
        CASE
            WHEN c.g15e05 > 0 THEN c.g15e05::double precision * ((d.anteil_feuer_gas_aelter93 / 100::numeric * (d.anteil_feuer_gas / 100::numeric))::double precision * d.energieverbr * (( SELECT b.schast_efak
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 67 AND b.s_code = 1 AND a.archive = 0 AND b.archive = 0))::double precision / f.sum_a00e05::double precision)
            ELSE 0::real::double precision
        END AS emiss_so2, 
        CASE
            WHEN c.g15e05 > 0 THEN c.g15e05::double precision * ((d.anteil_feuer_gas_aelter93 / 100::numeric * (d.anteil_feuer_gas / 100::numeric))::double precision * d.energieverbr * (( SELECT b.schast_efak
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 67 AND b.s_code = 26 AND a.archive = 0 AND b.archive = 0))::double precision / f.sum_a00e05::double precision)
            ELSE 0::real::double precision
        END AS emiss_n2o, 
        CASE
            WHEN c.g15e05 > 0 THEN c.g15e05::double precision * ((d.anteil_feuer_gas_aelter93 / 100::numeric * (d.anteil_feuer_gas / 100::numeric))::double precision * d.energieverbr * (( SELECT b.schast_efak
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 67 AND b.s_code = 7 AND a.archive = 0 AND b.archive = 0))::double precision / f.sum_a00e05::double precision)
            ELSE 0::real::double precision
        END AS emiss_pm10, 
        CASE
            WHEN c.g15e05 > 0 THEN c.g15e05::double precision * ((d.anteil_feuer_gas_aelter93 / 100::numeric * (d.anteil_feuer_gas / 100::numeric))::double precision * d.energieverbr * (( SELECT b.schast_efak
               FROM ekat2015.emiss_quelle a
          LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
         WHERE b.equelle_id = 67 AND b.s_code = 6 AND a.archive = 0 AND b.archive = 0))::double precision / f.sum_a00e05::double precision)
            ELSE 0::real::double precision
        END AS emiss_ch4
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT gmde_v.gem_bfs, gmde_v.einwohner, gmde_v.erdgasverbrauch, 
            gmde_v.mittlere_hoehe, gmde_v.klimaregion, 
            gmde_v.feuer_oel_aelter93, gmde_v.feuer_oel_juenger93, 
            gmde_v.feuer_gas_aelter93, gmde_v.feuer_gas_juenger93, 
            gmde_v.anteil_feuer_oel_aelter93, gmde_v.anteil_feuer_oel_juenger93, 
            gmde_v.anteil_feuer_oel, gmde_v.anteil_feuer_gas_aelter93, 
            gmde_v.anteil_feuer_gas_juenger93, gmde_v.anteil_feuer_gas, 
            gmde_v.anz_pw, gmde_v.anz_lnf_li, gmde_v.anz_mr, gmde_v.bezirk, 
            gmde_v.kt, gmde_v.name, gmde_v.heizgradtage, 
            gmde_v.heizgradtage_gem_ges, gmde_v.energieverbr, 
            gmde_v.wkb_geometry
           FROM ekat2015.gmde_v
          WHERE gmde_v.kt = 11::numeric) d ON a.gem_bfs = d.gem_bfs
   LEFT JOIN ( SELECT min(g.gem_bfs) AS gem_bfs_sum, 
       sum(h.g15e05) AS sum_a00e05
      FROM ekat2015.ha_raster_100 g
   LEFT JOIN geostat.gz15_minus_sammel_ha h ON g.xkoord = h.x_koord::numeric AND g.ykoord = h.y_koord::numeric
  WHERE g.archive = 0 AND h.archive = 0
  GROUP BY g.gem_bfs) f ON a.gem_bfs = f.gem_bfs_sum
   LEFT JOIN ( SELECT gz15_minus_sammel_ha.x_koord, 
    gz15_minus_sammel_ha.y_koord, gz15_minus_sammel_ha.g15e05
   FROM geostat.gz15_minus_sammel_ha
  WHERE gz15_minus_sammel_ha.archive = 0) c ON a.xkoord = c.x_koord::numeric AND a.ykoord = c.y_koord::numeric
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
