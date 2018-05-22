SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(d.emiss_nmvoc,0) + coalesce(e.emiss_nmvoc,0) + coalesce(f.emiss_nmvoc,0) + coalesce(g.emiss_nmvoc,0) + coalesce(h.emiss_nmvoc,0) 
  + coalesce(i.emiss_nmvoc,0) + coalesce(j.emiss_nmvoc,0) + coalesce(k.emiss_nmvoc,0) AS emiss_nmvoc
   FROM ekat2015.ug_verdampf_eq_tankatm_gem_pw d
   LEFT JOIN ekat2015.ug_verdampf_eq_tankatm_gem_li e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_verdampf_eq_tankatm_gem_mr f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_verdampf_eq_tankatm_str_pw g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_verdampf_eq_tankatm_str_li h ON g.xkoord = h.xkoord AND g.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_verdampf_eq_tankatm_str_mr i ON h.xkoord = i.xkoord AND h.ykoord = i.ykoord
   LEFT JOIN ekat2015.ug_verdampf_eq_motabst_pw j ON i.xkoord = j.xkoord AND i.ykoord = j.ykoord
   LEFT JOIN ekat2015.ug_verdampf_eq_motabst_li k ON i.xkoord = k.xkoord AND i.ykoord = k.ykoord
  ORDER BY d.xkoord, d.ykoord;
