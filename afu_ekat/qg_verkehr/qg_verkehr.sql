 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_so2 + e.emiss_so2::double precision + f.emiss_so2 + i.emiss_so2::double precision AS emiss_so2, 
    d.emiss_nox + e.emiss_nox::double precision + f.emiss_nox + h.emiss_nox::double precision + i.emiss_nox::double precision AS emiss_nox, 
    d.emiss_co + e.emiss_co::double precision + f.emiss_co + i.emiss_co::double precision AS emiss_co, 
    d.emiss_ch4 + e.emiss_ch4::double precision + f.emiss_ch4 AS emiss_ch4, 
    d.emiss_pm10 + e.emiss_pm10 + f.emiss_pm10 + h.emiss_pm10::double precision + i.emiss_pm10::double precision AS emiss_pm10, 
    d.emiss_nh3 + e.emiss_nh3::double precision AS emiss_nh3, 
    d.emiss_nmvoc + e.emiss_nmvoc::double precision + f.emiss_nmvoc + g.emiss_nmvoc + i.emiss_nmvoc::double precision AS emiss_nmvoc, 
    d.emiss_co2 + e.emiss_co2::double precision + i.emiss_co2::double precision AS emiss_co2, 
    d.emiss_n2o + e.emiss_n2o::double precision AS emiss_n2o
   FROM ekat2015.ug_strkvk_gesamt d
   LEFT JOIN ekat2015.ug_diff_verkehr_gesamt e ON d.xkoord = e.xkoord::numeric AND d.ykoord = e.ykoord::numeric
   LEFT JOIN ekat2015.ug_kaltstart_gesamt f ON e.xkoord::numeric = f.xkoord AND e.ykoord::numeric = f.ykoord
   LEFT JOIN ekat2015.ug_verdampf_gesamt g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_bahn_gesamt h ON g.xkoord = h.xkoord AND g.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_flug_gesamt i ON h.xkoord = i.xkoord AND h.ykoord = i.ykoord
  ORDER BY d.xkoord, d.ykoord;
