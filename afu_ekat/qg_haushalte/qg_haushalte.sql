 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_so2 + e.emiss_so2 + g.emiss_so2 AS emiss_so2, 
    d.emiss_nox + e.emiss_nox + g.emiss_nox AS emiss_nox, 
    d.emiss_co + e.emiss_co + g.emiss_co AS emiss_co, 
    d.emiss_ch4 + e.emiss_ch4 + g.emiss_ch4 AS emiss_ch4, 
    d.emiss_pm10 + e.emiss_pm10 + g.emiss_pm10 + i.emiss_pm10 AS emiss_pm10, 
    d.emiss_nh3 + e.emiss_nh3 + i.emiss_nh3 AS emiss_nh3, 
    d.emiss_nmvoc + e.emiss_nmvoc + f.emiss_nmvoc + g.emiss_nmvoc + i.emiss_nmvoc AS emiss_nmvoc, 
    d.emiss_co2 + e.emiss_co2 + g.emiss_co2 + i.emiss_co2 AS emiss_co2, 
    d.emiss_n2o + e.emiss_n2o + g.emiss_n2o + h.emiss_n2o::double precision AS emiss_n2o
   FROM ekat2015.ug_feuer_gesamt d
   LEFT JOIN ekat2015.ug_masch_gh_gesamt e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_loemittel_gesamt f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_abfallverbr_hh_gesamt g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_lachgas_hh_gesamt h ON g.xkoord = h.xkoord AND g.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_metaha_gesamt i ON h.xkoord = i.xkoord AND h.ykoord = i.ykoord
  ORDER BY d.xkoord, d.ykoord;
