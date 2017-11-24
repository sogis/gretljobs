 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_nmvoc + e.emiss_nmvoc + f.emiss_nmvoc + g.emiss_nmvoc + h.emiss_nmvoc + i.emiss_nmvoc AS emiss_nmvoc
   FROM ekat2015.ug_spez_emiss_eq_geb_rein d
   LEFT JOIN ekat2015.ug_spez_emiss_eq_klebst_anw e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_spez_emiss_eq_spray g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_spez_emiss_eq_rein_ind_uebrige h ON g.xkoord = h.xkoord AND g.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_spez_emiss_eq_holzschutz_anw i ON h.xkoord = i.xkoord AND h.ykoord = i.ykoord
  ORDER BY d.xkoord, d.ykoord;
