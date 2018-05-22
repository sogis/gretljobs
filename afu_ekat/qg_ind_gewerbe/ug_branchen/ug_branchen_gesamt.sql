 SELECT g.ogc_fid, g.xkoord, g.ykoord, g.wkb_geometry, g.gem_bfs, 
    coalesce(g.emiss_nmvoc,0) + coalesce(h.emiss_nmvoc,0) + coalesce(i.emiss_nmvoc,0) + coalesce(m.emiss_nmvoc,0) + coalesce(n.emiss_nmvoc,0) + coalesce(s.emiss_nmvoc,0) 
  + coalesce(u.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(t.emiss_pm10,0) AS emiss_pm10, 
    coalesce(g.emiss_co2,0) AS emiss_co2
   FROM ekat2015.ug_branchen_eq_benz_um_tklag g
   LEFT JOIN ekat2015.ug_branchen_eq_coiff_salons h ON g.xkoord = h.xkoord AND g.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_branchen_eq_farbanw_bau i ON h.xkoord = i.xkoord AND h.ykoord = i.ykoord
   LEFT JOIN ekat2015.ug_branchen_eq_holzbearb t ON i.xkoord = t.xkoord AND i.ykoord = t.ykoord
   LEFT JOIN ekat2015.ug_branchen_eq_klebst_prod m ON t.xkoord = m.xkoord AND t.ykoord = m.ykoord
   LEFT JOIN ekat2015.ug_branchen_eq_kosm_inst n ON m.xkoord = n.xkoord AND m.ykoord = n.ykoord
   LEFT JOIN ekat2015.ug_branchen_eq_str_bel_arb s ON n.xkoord = s.xkoord AND n.ykoord = s.ykoord
   LEFT JOIN ekat2015.ug_branchen_eq_uebr_ges_wes u ON s.xkoord = u.xkoord AND s.ykoord = u.ykoord
  ORDER BY g.xkoord, g.ykoord;
