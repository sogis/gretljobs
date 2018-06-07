 SELECT e.ogc_fid, e.xkoord, e.ykoord, e.wkb_geometry, e.gem_bfs, 
    coalesce(e.emiss_co,0) + coalesce(f.emiss_co,0) + coalesce(g.emiss_co,0) AS emiss_co, 
    coalesce(e.emiss_nox,0) + coalesce(f.emiss_nox,0) + coalesce(g.emiss_nox,0) AS emiss_nox, 
    coalesce(e.emiss_nmvoc,0) + coalesce(f.emiss_nmvoc,0) + coalesce(g.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(e.emiss_pm10,0) + coalesce(f.emiss_pm10,0) + coalesce(g.emiss_pm10,0) AS emiss_pm10, 
    coalesce(e.emiss_co2,0) + coalesce(f.emiss_co2,0) + coalesce(g.emiss_co2,0) AS emiss_co2, 
    coalesce(e.emiss_nh3,0) + coalesce(f.emiss_nh3,0) AS emiss_nh3, 
    coalesce(e.emiss_n2o,0) + coalesce(f.emiss_n2o,0) + coalesce(g.emiss_n2o,0) AS emiss_n2o, 
    coalesce(e.emiss_ch4,0) + coalesce(f.emiss_ch4,0) + coalesce(g.emiss_ch4,0) AS emiss_ch4, 
    coalesce(e.emiss_so2,0) + coalesce(f.emiss_so2,0) + coalesce(g.emiss_so2,0) AS emiss_so2
   FROM ekat2015.ug_masch_gh_eq_masch e
   LEFT JOIN ekat2015.ug_masch_gh_eq_mot_hh_dies f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_masch_gh_eq_mot_hh_gas g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
  ORDER BY e.xkoord, e.ykoord;
