 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, f.emiss_co, 
    e.emiss_co2, f.emiss_nox, f.emiss_so2, 
    e.emiss_nmvoc + f.emiss_nmvoc::double precision + g.emiss_nmvoc AS emiss_nmvoc, 
    d.emiss_ch4 + e.emiss_ch4 + f.emiss_ch4::double precision AS emiss_ch4, 
    f.emiss_nh3, f.emiss_n2o
   FROM ekat2015.ug_spez_branch_eq_deponien d
   LEFT JOIN ekat2015.ug_spez_branch_eq_gas_vert e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_spez_branch_eq_klaeranl f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_spez_branch_eq_med_praxen g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
  ORDER BY d.xkoord, d.ykoord;
