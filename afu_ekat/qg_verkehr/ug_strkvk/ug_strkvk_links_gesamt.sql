SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, d.vsit, 
    d.emiss_co + e.emiss_co + f.emiss_co + g.emiss_co + i.emiss_co AS emiss_co, 
    d.emiss_co2 + e.emiss_co2 + f.emiss_co2 + g.emiss_co2 + i.emiss_co2 AS emiss_co2, 
    d.emiss_nox + e.emiss_nox + f.emiss_nox + g.emiss_nox + i.emiss_nox AS emiss_nox, 
    d.emiss_so2 + e.emiss_so2 + f.emiss_so2 + g.emiss_so2 + i.emiss_so2 AS emiss_so2, 
    d.emiss_nmvoc + e.emiss_nmvoc + f.emiss_nmvoc + g.emiss_nmvoc + i.emiss_nmvoc AS emiss_nmvoc, 
    d.emiss_ch4 + e.emiss_ch4 + f.emiss_ch4 + g.emiss_ch4 + i.emiss_ch4 AS emiss_ch4, 
    d.emiss_nh3 + e.emiss_nh3 + f.emiss_nh3 + g.emiss_nh3 + i.emiss_nh3 AS emiss_nh3, 
    d.emiss_n2o + e.emiss_n2o + f.emiss_n2o + g.emiss_n2o + i.emiss_n2o AS emiss_n2o, 
    d.emiss_pm10 + e.emiss_pm10 + f.emiss_pm10 + g.emiss_pm10 + i.emiss_pm10 AS emiss_pm10
   FROM ekat2015.ug_strkvk_eq_pw d
   JOIN ekat2015.ug_strkvk_eq_li e ON e.xkoord = d.xkoord AND e.ykoord = d.ykoord
   JOIN ekat2015.ug_strkvk_eq_mr f ON f.xkoord = e.xkoord AND f.ykoord = e.ykoord
   JOIN ekat2015.ug_strkvk_eq_snf g ON g.xkoord = f.xkoord AND g.ykoord = f.ykoord
   JOIN ekat2015.ug_strkvk_eq_rb i ON i.xkoord = g.xkoord AND i.ykoord = g.ykoord
  ORDER BY d.xkoord, d.ykoord;
