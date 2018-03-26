SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_co + e.emiss_co AS emiss_co, d.emiss_nox + e.emiss_nox AS emiss_nox, 
    d.emiss_so2 + e.emiss_so2 AS emiss_so2, 
    d.emiss_nmvoc + e.emiss_nmvoc AS emiss_nmvoc, 
    d.emiss_ch4 + e.emiss_ch4 AS emiss_ch4, 
    d.emiss_pm10 + e.emiss_pm10 AS emiss_pm10
   FROM ekat2015.ug_kaltstart_eq_pw d
   LEFT JOIN ekat2015.ug_kaltstart_eq_li e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
  ORDER BY d.xkoord, d.ykoord;
