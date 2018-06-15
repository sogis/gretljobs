SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(h.emiss_co,0) AS emiss_co, 
    coalesce(h.emiss_co2,0) AS emiss_co2, 
    coalesce(h.emiss_nox,0) AS emiss_nox, 
    coalesce(h.emiss_so2,0) AS emiss_so2, 
    coalesce(d.emiss_nmvoc,0) + coalesce(e.emiss_nmvoc,0) + coalesce(h.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(h.emiss_ch4,0) AS emiss_ch4, 
    coalesce(f.emiss_pm10,0) + coalesce(g.emiss_pm10,0) + coalesce(h.emiss_pm10,0) AS emiss_pm10, 
    coalesce(h.emiss_nh3,0) AS emiss_nh3, 
    coalesce(h.emiss_n2o,0) AS emiss_n2o 
   FROM ekat2015.ug_anl_proz_eq_dachpa_verl d
   LEFT JOIN ekat2015.ug_anl_proz_eq_met_rein e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_anl_proz_eq_baumasch_aufw f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_anl_proz_eq_ind_aufw g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_anl_proz_eq_baumasch_innermot h ON e.xkoord = h.xkoord AND e.ykoord = h.ykoord
  ORDER BY d.xkoord, d.ykoord;
