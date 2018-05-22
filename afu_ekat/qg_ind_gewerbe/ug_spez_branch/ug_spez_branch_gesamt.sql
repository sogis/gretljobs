 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(f.emiss_co,0) AS emiss_co, 
    coalesce(e.emiss_co2,0) AS emiss_co2, 
    coalesce(f.emiss_nox,0) AS emiss_nox, 
    coalesce(f.emiss_so2,0) AS emiss_so2, 
    coalesce(e.emiss_nmvoc,0) + coalesce(f.emiss_nmvoc,0) + coalesce(g.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(d.emiss_ch4,0) + coalesce(e.emiss_ch4,0) + coalesce(f.emiss_ch4,0) AS emiss_ch4, 
    coalesce(f.emiss_nh3,0) AS emiss_nh3, 
    coalesce(f.emiss_n2o,0) AS emiss_n2o
   FROM ekat2015.ug_spez_branch_eq_deponien d
   LEFT JOIN ekat2015.ug_spez_branch_eq_gas_vert e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_spez_branch_eq_klaeranl f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_spez_branch_eq_med_praxen g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
  ORDER BY d.xkoord, d.ykoord;
