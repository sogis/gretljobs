 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_co + e.emiss_co AS emiss_co, d.emiss_co2 + e.emiss_co2 AS emiss_co2, 
    d.emiss_nox + e.emiss_nox AS emiss_nox, 
    d.emiss_so2 + e.emiss_so2 AS emiss_so2, 
    d.emiss_nmvoc + e.emiss_nmvoc AS emiss_nmvoc, 
    d.emiss_ch4 + e.emiss_ch4 AS emiss_ch4, 
    d.emiss_pm10 + e.emiss_pm10 AS emiss_pm10, 
    d.emiss_nh3 + e.emiss_nh3 AS emiss_nh3, 
    d.emiss_n2o + e.emiss_n2o AS emiss_n2o, 
    d.emiss_xkw + e.emiss_xkw AS emiss_xkw
   FROM ekat2015.ug_uplus_eq_punktemiss d
   LEFT JOIN ekat2015.ug_uplus_eq_flaeche e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
  ORDER BY d.xkoord, d.ykoord;
