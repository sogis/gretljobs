SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    f.emiss_so2 + g.emiss_so2 AS emiss_so2, 
    d.emiss_nox::double precision + e.emiss_nox + f.emiss_nox + g.emiss_nox AS emiss_nox, 
    f.emiss_co + g.emiss_co AS emiss_co, 
    d.emiss_ch4::double precision + f.emiss_ch4 + g.emiss_ch4 AS emiss_ch4, 
    d.emiss_pm10::double precision + f.emiss_pm10 + g.emiss_pm10 AS emiss_pm10, 
    d.emiss_nh3 + e.emiss_nh3 + f.emiss_nh3 + g.emiss_nh3 AS emiss_nh3, 
    f.emiss_nmvoc + g.emiss_nmvoc AS emiss_nmvoc, 
    f.emiss_co2 + g.emiss_co2 AS emiss_co2, 
    d.emiss_n2o::double precision + e.emiss_n2o + f.emiss_n2o + g.emiss_n2o AS emiss_n2o
   FROM ekat2015.ug_nutztier_gesamt d
   LEFT JOIN ekat2015.ug_nutzdue_gesamt e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_maschinen_gesamt f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_abfallverbr_gesamt g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
  ORDER BY d.xkoord, d.ykoord;
