 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_nox + e.emiss_nox + f.emiss_nox + g.emiss_nox AS emiss_nox, 
    d.emiss_nmvoc + e.emiss_nmvoc + f.emiss_nmvoc + g.emiss_nmvoc AS emiss_nmvoc, 
    d.emiss_ch4 + e.emiss_ch4 + f.emiss_ch4 + (+ g.emiss_ch4) AS emiss_ch4, 
    d.emiss_n2o + e.emiss_n2o + f.emiss_n2o + g.emiss_n2o AS emiss_n2o
   FROM ekat2015.ug_waelder_eq_laub d
   LEFT JOIN ekat2015.ug_waelder_eq_laubmisch e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_waelder_eq_nadelmisch f ON d.xkoord = f.xkoord AND d.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_waelder_eq_nadel g ON d.xkoord = g.xkoord AND d.ykoord = g.ykoord
  ORDER BY d.xkoord, d.ykoord;
