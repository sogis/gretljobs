SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(d.emiss_nmvoc,0) + coalesce(e.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(f.emiss_pm10,0) + coalesce(g.emiss_pm10,0) AS emiss_pm10
   FROM ekat2015.ug_anl_proz_eq_dachpa_verl d
   LEFT JOIN ekat2015.ug_anl_proz_eq_met_rein e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_anl_proz_eq_baumasch_aufw f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_anl_proz_eq_ind_aufw g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
  ORDER BY d.xkoord, d.ykoord;
