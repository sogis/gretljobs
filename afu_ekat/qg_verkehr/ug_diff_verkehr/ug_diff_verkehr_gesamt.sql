SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_co + k.emiss_co AS emiss_co, 
    d.emiss_co2 + k.emiss_co2 AS emiss_co2, 
    d.emiss_nox + k.emiss_nox AS emiss_nox, 
    d.emiss_so2 + k.emiss_so2 AS emiss_so2, 
    d.emiss_nmvoc + k.emiss_nmvoc AS emiss_nmvoc, 
    d.emiss_ch4 + k.emiss_ch4 AS emiss_ch4, 
    d.emiss_nh3 + k.emiss_nh3 AS emiss_nh3, 
    d.emiss_n2o + k.emiss_n2o AS emiss_n2o, 
    (d.emiss_pm10)::double precision + f.emiss_pm10 + g.emiss_pm10 + h.emiss_pm10 + i.emiss_pm10 + k.emiss_pm10::double precision AS emiss_pm10
   FROM ekat2015.ug_diff_verkehr_eq_pw d
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_lnf k ON d.xkoord = k.xkoord AND d.ykoord = k.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_lmw f ON d.xkoord::numeric = f.xkoord AND d.ykoord::numeric = f.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_smw g ON d.xkoord = g.xkoord AND d.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_mr_2t h ON d.xkoord = h.xkoord AND d.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_mr_4t i ON d.xkoord = i.xkoord AND d.ykoord = i.ykoord
  ORDER BY d.xkoord, d.ykoord;
