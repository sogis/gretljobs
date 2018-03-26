SELECT min(k.ogc_fid) AS ogc_fid, k.xkoord, k.ykoord, 
    min(k.wkb_geometry::text) AS wkb_geometry, min(k.gem_bfs) AS gem_bfs, 
    sum(k.emiss_co) AS emiss_co, sum(k.emiss_co2) AS emiss_co2, 
    sum(k.emiss_nox) AS emiss_nox, sum(k.emiss_so2) AS emiss_so2, 
    sum(k.emiss_nmvoc) AS emiss_nmvoc, sum(k.emiss_ch4) AS emiss_ch4, 
    sum(k.emiss_nh3) AS emiss_nh3, sum(k.emiss_n2o) AS emiss_n2o, 
    sum(k.emiss_pm10) AS emiss_pm10
   FROM ( SELECT a.ogc_fid, a.xkoord, a.ykoord, ha_raster_100.wkb_geometry, 
            a.gem_bfs, 
                CASE
                    WHEN (a.arb_plaetze_zone > 0::numeric OR a.einw_zone > 0::numeric) AND a.vsit::text = 'Agglo/Erschliessung/50'::text THEN (a.p00btot + a.b05empts2 + a.b05empts3) * ((( SELECT efak_diff_verkehr.efak
                       FROM ekat2015.efak_diff_verkehr
                      WHERE efak_diff_verkehr.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND efak_diff_verkehr.schast = 5 AND efak_diff_verkehr.fhz_art = 'LNF'::text AND efak_diff_verkehr.archive = 0))::numeric * a.dtv_li * a.laenge * 365::numeric / 1000::numeric) / (a.arb_plaetze_zone + a.einw_zone)
                    ELSE 0::numeric
                END AS emiss_co, 
                CASE
                    WHEN (a.arb_plaetze_zone > 0::numeric OR a.einw_zone > 0::numeric) AND a.vsit::text = 'Agglo/Erschliessung/50'::text THEN (a.p00btot + a.b05empts2 + a.b05empts3) * ((( SELECT efak_diff_verkehr.efak
                       FROM ekat2015.efak_diff_verkehr
                      WHERE efak_diff_verkehr.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND efak_diff_verkehr.schast = 25 AND efak_diff_verkehr.fhz_art = 'LNF'::text AND efak_diff_verkehr.archive = 0))::numeric * a.dtv_li * a.laenge * 365::numeric / 1000::numeric) / (a.arb_plaetze_zone + a.einw_zone)
                    ELSE 0::numeric
                END AS emiss_co2, 
                CASE
                    WHEN (a.arb_plaetze_zone > 0::numeric OR a.einw_zone > 0::numeric) AND a.vsit::text = 'Agglo/Erschliessung/50'::text THEN (a.p00btot + a.b05empts2 + a.b05empts3) * ((( SELECT efak_diff_verkehr.efak
                       FROM ekat2015.efak_diff_verkehr
                      WHERE efak_diff_verkehr.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND efak_diff_verkehr.schast = 2 AND efak_diff_verkehr.fhz_art = 'LNF'::text AND efak_diff_verkehr.archive = 0))::numeric * a.dtv_li * a.laenge * 365::numeric / 1000::numeric) / (a.arb_plaetze_zone + a.einw_zone)
                    ELSE 0::numeric
                END AS emiss_nox, 
                CASE
                    WHEN (a.arb_plaetze_zone > 0::numeric OR a.einw_zone > 0::numeric) AND a.vsit::text = 'Agglo/Erschliessung/50'::text THEN (a.p00btot + a.b05empts2 + a.b05empts3) * ((( SELECT efak_diff_verkehr.efak
                       FROM ekat2015.efak_diff_verkehr
                      WHERE efak_diff_verkehr.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND efak_diff_verkehr.schast = 1 AND efak_diff_verkehr.fhz_art = 'LNF'::text AND efak_diff_verkehr.archive = 0))::numeric * a.dtv_li * a.laenge * 365::numeric / 1000::numeric) / (a.arb_plaetze_zone + a.einw_zone)
                    ELSE 0::numeric
                END AS emiss_so2, 
                CASE
                    WHEN (a.arb_plaetze_zone > 0::numeric OR a.einw_zone > 0::numeric) AND a.vsit::text = 'Agglo/Erschliessung/50'::text THEN (a.p00btot + a.b05empts2 + a.b05empts3) * ((( SELECT efak_diff_verkehr.efak
                       FROM ekat2015.efak_diff_verkehr
                      WHERE efak_diff_verkehr.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND efak_diff_verkehr.schast = 22 AND efak_diff_verkehr.fhz_art = 'LNF'::text AND efak_diff_verkehr.archive = 0))::numeric * a.dtv_li * a.laenge * 365::numeric / 1000::numeric) / (a.arb_plaetze_zone + a.einw_zone)
                    ELSE 0::numeric
                END AS emiss_nmvoc, 
                CASE
                    WHEN (a.arb_plaetze_zone > 0::numeric OR a.einw_zone > 0::numeric) AND a.vsit::text = 'Agglo/Erschliessung/50'::text THEN (a.p00btot + a.b05empts2 + a.b05empts3) * ((( SELECT efak_diff_verkehr.efak
                       FROM ekat2015.efak_diff_verkehr
                      WHERE efak_diff_verkehr.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND efak_diff_verkehr.schast = 6 AND efak_diff_verkehr.fhz_art = 'LNF'::text AND efak_diff_verkehr.archive = 0))::numeric * a.dtv_li * a.laenge * 365::numeric / 1000::numeric) / (a.arb_plaetze_zone + a.einw_zone)
                    ELSE 0::numeric
                END AS emiss_ch4, 
                CASE
                    WHEN (a.arb_plaetze_zone > 0::numeric OR a.einw_zone > 0::numeric) AND a.vsit::text = 'Agglo/Erschliessung/50'::text THEN (a.p00btot + a.b05empts2 + a.b05empts3) * ((( SELECT efak_diff_verkehr.efak
                       FROM ekat2015.efak_diff_verkehr
                      WHERE efak_diff_verkehr.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND efak_diff_verkehr.schast = 8 AND efak_diff_verkehr.fhz_art = 'LNF'::text AND efak_diff_verkehr.archive = 0))::numeric * a.dtv_li * a.laenge * 365::numeric / 1000::numeric) / (a.arb_plaetze_zone + a.einw_zone)
                    ELSE 0::numeric
                END AS emiss_nh3, 
                CASE
                    WHEN (a.arb_plaetze_zone > 0::numeric OR a.einw_zone > 0::numeric) AND a.vsit::text = 'Agglo/Erschliessung/50'::text THEN (a.p00btot + a.b05empts2 + a.b05empts3) * ((( SELECT efak_diff_verkehr.efak
                       FROM ekat2015.efak_diff_verkehr
                      WHERE efak_diff_verkehr.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND efak_diff_verkehr.schast = 26 AND efak_diff_verkehr.fhz_art = 'LNF'::text AND efak_diff_verkehr.archive = 0))::numeric * a.dtv_li * a.laenge * 365::numeric / 1000::numeric) / (a.arb_plaetze_zone + a.einw_zone)
                    ELSE 0::numeric
                END AS emiss_n2o, 
                CASE
                    WHEN (a.arb_plaetze_zone > 0::numeric OR a.einw_zone > 0::numeric) AND a.vsit::text = 'Agglo/Erschliessung/50'::text THEN (a.p00btot + a.b05empts2 + a.b05empts3) * ((( SELECT efak_diff_verkehr.efak
                       FROM ekat2015.efak_diff_verkehr
                      WHERE efak_diff_verkehr.vk_sit = 'Agglo/Erschliessung/50/fluessig'::text AND efak_diff_verkehr.schast = 7 AND efak_diff_verkehr.fhz_art = 'LNF'::text AND efak_diff_verkehr.archive = 0))::numeric * a.dtv_li * a.laenge * 365::numeric / 1000::numeric) / (a.arb_plaetze_zone + a.einw_zone)
                    ELSE 0::numeric
                END AS emiss_pm10
           FROM ekat2015.ha_raster_100
      LEFT JOIN ekat2015.intersec_vk_zone_ha_raster a ON ha_raster_100.xkoord = a.xkoord::numeric AND ha_raster_100.ykoord = a.ykoord::numeric
     WHERE a.archive = 0) k
  GROUP BY k.xkoord, k.ykoord
  ORDER BY min(k.gem_bfs), k.xkoord, k.ykoord;
