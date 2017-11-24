 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    f.emiss_co + h.emiss_co AS emiss_co, 
    e.emiss_co2 + f.emiss_co2 + h.emiss_co2::double precision AS emiss_co2, 
    f.emiss_nox + h.emiss_nox AS emiss_nox, 
    f.emiss_so2 + h.emiss_so2 AS emiss_so2, 
    d.emiss_nmvoc + e.emiss_nmvoc + f.emiss_nmvoc + g.emiss_nmvoc + h.emiss_nmvoc::double precision AS emiss_nmvoc, 
    f.emiss_ch4 + h.emiss_ch4::double precision AS emiss_ch4, 
    d.emiss_pm10 + e.emiss_pm10 + h.emiss_pm10::double precision AS emiss_pm10, 
    f.emiss_nh3 + h.emiss_nh3 AS emiss_nh3, 
    f.emiss_n2o + h.emiss_n2o AS emiss_n2o, h.emiss_xkw
   FROM ekat2015.ug_anl_proz_gesamt d
   LEFT JOIN ekat2015.ug_branchen_gesamt e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_spez_branch_gesamt f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_spez_emiss_gesamt g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_uplus_gesamt h ON g.xkoord = h.xkoord AND g.ykoord = h.ykoord
  ORDER BY d.xkoord, d.ykoord;
