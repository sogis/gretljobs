 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_co + e.emiss_co AS emiss_co, d.emiss_co2 + e.emiss_co2 AS emiss_co2, 
    d.emiss_nox + e.emiss_nox AS emiss_nox, 
    d.emiss_so2 + e.emiss_so2 AS emiss_so2, e.emiss_nmvoc, 
    d.emiss_pm10 + e.emiss_pm10 AS emiss_pm10, e.emiss_ch4, e.emiss_n2o
   FROM ekat2015.ug_abfallverbr_hh_eq_feuwer d
   LEFT JOIN ekat2015.ug_abfallverbr_hh_eq_abfallverbr e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
  ORDER BY d.xkoord, d.ykoord;
