SELECT min(c.ogc_fid) AS ogc_fid, min(c.xkoord)::numeric AS xkoord, 
    min(c.ykoord)::numeric AS ykoord, c.wkb_geometry, min(c.gem_bfs) AS gem_bfs, 
    sum(c.emiss_pm10) AS emiss_pm10
   FROM ( SELECT k.ogc_fid, k.xkoord, k.ykoord, k.wkb_geometry, k.gem_bfs, 
                CASE
                    WHEN k.arb_plaetze_zone > 0::numeric OR k.einw_zone > 0::numeric THEN (k.p00btot + k.b05empts2 + k.b05empts3)::double precision * (((( SELECT b.schast_efak
                       FROM ekat2015.emiss_quelle a
                  LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
                 WHERE a.equelle_id = 58 AND b.s_code = 7 AND a.archive = 0 AND b.archive = 0)) * (k.anz_smw / (k.anz_smw + k.anz_lmw + k.anz_mr_2t + k.anz_mr_4t)))::double precision * (k.dtv_pw + k.dtv_li) * k.laenge * 365::numeric::double precision) / (k.arb_plaetze_zone + k.einw_zone)::double precision
                    ELSE 0::numeric::double precision
                END AS emiss_pm10
           FROM ( SELECT a.ogc_fid, a.xkoord, a.ykoord, 
                    a.wkb_geometry_ha_rast AS wkb_geometry, a.gem_bfs, 
                    c.anz_lmw, c.anz_smw, c.anz_mr_2t, c.anz_mr_4t, 
                    b.arb_plaetze_zone, b.einw_zone, b.dtv_pw, b.dtv_li, 
                    a.vk_zone, a.p00btot, a.b05empts2, a.b05empts3, b.laenge
                   FROM ekat2015.intersec_vk_zone_ha_raster a
              LEFT JOIN ( SELECT vk_zonen.zonennummer, 
                            vk_zonen.dtv_pw, 
                            vk_zonen.dtv_li, 
                            vk_zonen.arb_plaetze_zone, 
                            vk_zonen.einw_zone, 
                            vk_zonen.laenge
                           FROM ekat2015.vk_zonen) b ON a.vk_zone::double precision = b.zonennummer
         LEFT JOIN ( SELECT gmde.gem_bfs, gmde.anz_smw, gmde.anz_lmw, 
                       gmde.anz_mr_2t, gmde.anz_mr_4t
                      FROM ekat2015.gmde
                     WHERE gmde.archive = 0 AND gmde.gem_bfs >= 2401 AND gmde.gem_bfs <= 2622) c ON a.gem_bfs = c.gem_bfs) k) c
  GROUP BY c.wkb_geometry
  ORDER BY min(c.xkoord)::numeric, min(c.ykoord)::numeric;
