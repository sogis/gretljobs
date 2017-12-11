 SELECT e.ogc_fid, e.xkoord, e.ykoord, e.wkb_geometry, e.gem_bfs, 
    e.emiss_co + f.emiss_co + g.emiss_co AS emiss_co, 
    e.emiss_nox + f.emiss_nox + g.emiss_nox AS emiss_nox, 
    e.emiss_nmvoc + f.emiss_nmvoc + g.emiss_nmvoc AS emiss_nmvoc, 
    f.emiss_pm10 + g.emiss_pm10 AS emiss_pm10, 
    e.emiss_co2 + f.emiss_co2 + g.emiss_co2 AS emiss_co2, f.emiss_nh3, 
    f.emiss_n2o + g.emiss_n2o AS emiss_n2o, 
    f.emiss_ch4 + g.emiss_ch4 AS emiss_ch4, 
    f.emiss_so2 + g.emiss_so2 AS emiss_so2
   FROM ekat2015.ug_masch_gh_eq_masch e
   LEFT JOIN ekat2015.ug_masch_gh_eq_mot_hh_dies f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_masch_gh_eq_mot_hh_gas g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
  ORDER BY e.xkoord, e.ykoord;
