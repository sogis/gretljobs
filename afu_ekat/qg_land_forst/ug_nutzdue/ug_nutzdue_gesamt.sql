SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, f.emiss_nox, 
    d.emiss_n2o::double precision + f.emiss_n2o AS emiss_n2o, 
    d.emiss_nh3 + e.emiss_nh3 AS emiss_nh3
   FROM ekat2015.ug_nutzdue_eq_hofdue_transfer d
   LEFT JOIN ekat2015.ug_nutzdue_eq_nutzdue_nh3 e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_nutzdue_eq_nutzdue_nox_n2o f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
  ORDER BY d.xkoord, d.ykoord;
