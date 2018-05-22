SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(d.emiss_co,0) + coalesce(k.emiss_co,0) AS emiss_co, 
    coalesce(d.emiss_co2,0) + coalesce(k.emiss_co2,0) AS emiss_co2, 
    coalesce(d.emiss_nox,0) + coalesce(k.emiss_nox,0) AS emiss_nox, 
    coalesce(d.emiss_so2,0) + coalesce(k.emiss_so2,0) AS emiss_so2, 
    coalesce(d.emiss_nmvoc,0) + coalesce(k.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(d.emiss_ch4,0) + coalesce(k.emiss_ch4,0) AS emiss_ch4, 
    coalesce(d.emiss_nh3,0) + coalesce(k.emiss_nh3,0) AS emiss_nh3, 
    coalesce(d.emiss_n2o,0) + coalesce(k.emiss_n2o,0) AS emiss_n2o, 
    coalesce(d.emiss_pm10,0) + coalesce(f.emiss_pm10,0) + coalesce(g.emiss_pm10,0) + coalesce(h.emiss_pm10,0) + coalesce(i.emiss_pm10,0) + coalesce(k.emiss_pm10,0) AS emiss_pm10
   FROM ekat2015.ug_diff_verkehr_eq_pw d
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_lnf k ON d.xkoord = k.xkoord AND d.ykoord = k.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_lmw f ON d.xkoord::numeric = f.xkoord AND d.ykoord::numeric = f.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_smw g ON d.xkoord = g.xkoord AND d.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_mr_2t h ON d.xkoord = h.xkoord AND d.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_mr_4t i ON d.xkoord = i.xkoord AND d.ykoord = i.ykoord
  ORDER BY d.xkoord, d.ykoord;
