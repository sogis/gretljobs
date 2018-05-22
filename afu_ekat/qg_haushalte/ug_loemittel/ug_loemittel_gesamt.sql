 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(d.emiss_nmvoc,0) + coalesce(e.emiss_nmvoc,0) + coalesce(f.emiss_nmvoc,0) + coalesce(g.emiss_nmvoc,0) AS emiss_nmvoc
   FROM ekat2015.ug_loemittel_eq_farbanw d
   LEFT JOIN ekat2015.ug_loemittel_eq_pharma e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_loemittel_eq_reiloe_mittel f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_loemittel_eq_spraydosen g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
  ORDER BY d.xkoord, d.ykoord;
