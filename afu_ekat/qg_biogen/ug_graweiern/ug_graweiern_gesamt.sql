 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_nox + e.emiss_nox AS emiss_nox, 
    d.emiss_nmvoc + e.emiss_nmvoc + f.emiss_nmvoc AS emiss_nmvoc, 
    d.emiss_ch4 + e.emiss_ch4 AS emiss_ch4, 
    d.emiss_nh3 + e.emiss_nh3 AS emiss_nh3, 
    d.emiss_n2o + e.emiss_n2o AS emiss_n2o
   FROM ekat2015.ug_graweiern_eq_gras d
   LEFT JOIN ekat2015.ug_graweiern_eq_weide e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_graweiern_eq_bodenemissionen f ON d.xkoord = f.xkoord AND d.ykoord = f.ykoord
  ORDER BY d.xkoord, d.ykoord;
