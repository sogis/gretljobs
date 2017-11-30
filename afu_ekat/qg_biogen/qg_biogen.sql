 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    0 AS emiss_so2, 
    d.emiss_nox + e.emiss_nox::double precision + f.emiss_nox::double precision + g.emiss_nox::double precision AS emiss_nox, 
    0 AS emiss_co, 
    d.emiss_ch4 + e.emiss_ch4::double precision + f.emiss_ch4::double precision AS emiss_ch4, 
    0 AS emiss_pm10, e.emiss_nh3, 
    d.emiss_nmvoc + e.emiss_nmvoc::double precision AS emiss_nmvoc, 
    0 AS emiss_co2, 
    d.emiss_n2o + e.emiss_n2o::double precision + f.emiss_n2o::double precision AS emiss_n2o
   FROM ekat2015.ug_waelder_gesamt d
   LEFT JOIN ekat2015.ug_graweiern_gesamt e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_gewaesser_gesamt f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_blitze g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
  ORDER BY d.xkoord, d.ykoord;
