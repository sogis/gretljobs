 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(d.emiss_so2,0) + coalesce(e.emiss_so2,0) + coalesce(g.emiss_so2,0) AS emiss_so2, 
    coalesce(d.emiss_nox,0) + coalesce(e.emiss_nox,0) + coalesce(g.emiss_nox,0) AS emiss_nox, 
    coalesce(d.emiss_co,0) + coalesce(e.emiss_co,0) + coalesce(g.emiss_co,0) AS emiss_co, 
    coalesce(d.emiss_ch4,0) + coalesce(e.emiss_ch4,0) + coalesce(g.emiss_ch4,0) AS emiss_ch4, 
    coalesce(d.emiss_pm10,0) + coalesce(e.emiss_pm10,0) + coalesce(g.emiss_pm10,0) + coalesce(i.emiss_pm10,0) AS emiss_pm10, 
    coalesce(d.emiss_nh3,0) + coalesce(e.emiss_nh3,0) + coalesce(i.emiss_nh3,0) AS emiss_nh3, 
    coalesce(d.emiss_nmvoc,0) + coalesce(e.emiss_nmvoc,0) + coalesce(f.emiss_nmvoc,0) + coalesce(g.emiss_nmvoc,0) + coalesce(i.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(d.emiss_co2,0) + coalesce(e.emiss_co2,0) + coalesce(g.emiss_co2,0) + coalesce(i.emiss_co2,0) AS emiss_co2, 
    coalesce(d.emiss_n2o,0) + coalesce(e.emiss_n2o,0) + coalesce(g.emiss_n2o,0) + coalesce(h.emiss_n2o,0) AS emiss_n2o
   FROM ekat2015.ug_feuer_gesamt d
   LEFT JOIN ekat2015.ug_masch_gh_gesamt e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_loemittel_gesamt f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_abfallverbr_hh_gesamt g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_lachgas_hh_gesamt h ON g.xkoord = h.xkoord AND g.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_metaha_gesamt i ON h.xkoord = i.xkoord AND h.ykoord = i.ykoord
  ORDER BY d.xkoord, d.ykoord;
