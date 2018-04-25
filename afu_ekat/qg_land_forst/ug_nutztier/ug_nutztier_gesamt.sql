 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_nh3 + e.emiss_nh3::double precision AS emiss_nh3, 
    d.emiss_pm10 + e.emiss_pm10 AS emiss_pm10, 
    d.emiss_ch4 + e.emiss_ch4 + f.emiss_ch4 + g.emiss_ch4 AS emiss_ch4, 
    d.emiss_n2o + e.emiss_n2o AS emiss_n2o, 
    d.emiss_nox + e.emiss_nox AS emiss_nox
   FROM ekat2015.ug_nutztier_eq_exkr_punktquelle d
   LEFT JOIN ekat2015.ug_nutztier_eq_exkr_flaeche e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_nutztier_eq_ferm_punktquelle f ON d.xkoord = f.xkoord AND d.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_nutztier_eq_ferm_flaeche g ON d.xkoord = g.xkoord AND d.ykoord = g.ykoord
  ORDER BY d.xkoord, d.ykoord;
