 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(d.emiss_co,0) + coalesce(e.emiss_co,0) AS emiss_co, 
    coalesce(d.emiss_co2,0) + coalesce(e.emiss_co2,0) AS emiss_co2, 
    coalesce(d.emiss_nox,0) + coalesce(e.emiss_nox,0) AS emiss_nox, 
    coalesce(d.emiss_so2,0) + coalesce(e.emiss_so2,0) AS emiss_so2, 
    coalesce(d.emiss_nmvoc,0) + coalesce(e.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(d.emiss_ch4,0) + coalesce(e.emiss_ch4,0) AS emiss_ch4, 
    coalesce(d.emiss_pm10,0) + coalesce(e.emiss_pm10,0) AS emiss_pm10, 
    coalesce(d.emiss_nh3,0) + coalesce(e.emiss_nh3,0) AS emiss_nh3, 
    coalesce(d.emiss_n2o,0) + coalesce(e.emiss_n2o,0) AS emiss_n2o, 
    coalesce(d.emiss_xkw,0) + coalesce(e.emiss_xkw,0) AS emiss_xkw
   FROM ekat2015.ug_uplus_eq_punktemiss d
   LEFT JOIN ekat2015.ug_uplus_eq_flaeche e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
  ORDER BY d.xkoord, d.ykoord;
