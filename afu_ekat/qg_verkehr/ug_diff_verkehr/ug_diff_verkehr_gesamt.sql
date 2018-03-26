SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_co + e.emiss_co + j.emiss_co + k.emiss_co AS emiss_co, 
    d.emiss_co2 + e.emiss_co2 + j.emiss_co2 + k.emiss_co2 AS emiss_co2, 
    d.emiss_nox + e.emiss_nox + j.emiss_nox + k.emiss_nox AS emiss_nox, 
    d.emiss_so2 + e.emiss_so2 + (+ j.emiss_so2) + k.emiss_so2 AS emiss_so2, 
    d.emiss_nmvoc + e.emiss_nmvoc + j.emiss_nmvoc + k.emiss_nmvoc AS emiss_nmvoc, 
    d.emiss_ch4 + e.emiss_ch4 + j.emiss_ch4 + k.emiss_ch4 AS emiss_ch4, 
    d.emiss_nh3 + e.emiss_nh3 + j.emiss_nh3 + k.emiss_nh3 AS emiss_nh3, 
    d.emiss_n2o + e.emiss_n2o + j.emiss_n2o + k.emiss_n2o AS emiss_n2o, 
    (d.emiss_pm10 + e.emiss_pm10)::double precision + f.emiss_pm10 + g.emiss_pm10 + h.emiss_pm10 + i.emiss_pm10 + j.emiss_pm10::double precision + k.emiss_pm10::double precision AS emiss_pm10
   FROM ekat2015.ug_diff_verkehr_eq_pw_vsit_agglo d
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_lnf_vsit_agglo e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_lmw f ON e.xkoord::numeric = f.xkoord AND e.ykoord::numeric = f.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_smw g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_mr_2t h ON g.xkoord = h.xkoord AND g.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_aufw_abr_mr_4t i ON h.xkoord = i.xkoord AND h.ykoord = i.ykoord
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_pw_vsit_land j ON i.xkoord = j.xkoord::numeric AND i.ykoord = j.ykoord::numeric
   LEFT JOIN ekat2015.ug_diff_verkehr_eq_lnf_vsit_land k ON j.xkoord = k.xkoord AND j.ykoord = k.ykoord
  ORDER BY d.xkoord, d.ykoord;
