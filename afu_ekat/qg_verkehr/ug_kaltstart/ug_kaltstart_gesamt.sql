SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(d.emiss_co,0) + coalesce(e.emiss_co,0) AS emiss_co, 
    coalesce(d.emiss_nox,0) + coalesce(e.emiss_nox,0) AS emiss_nox, 
    coalesce(d.emiss_so2,0) + coalesce(e.emiss_so2,0) AS emiss_so2, 
    coalesce(d.emiss_nmvoc,0) + coalesce(e.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(d.emiss_ch4,0) + coalesce(e.emiss_ch4,0) AS emiss_ch4, 
    coalesce(d.emiss_pm10,0) + coalesce(e.emiss_pm10,0) AS emiss_pm10
   FROM ekat2015.ug_kaltstart_eq_pw d
   LEFT JOIN ekat2015.ug_kaltstart_eq_li e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
  ORDER BY d.xkoord, d.ykoord;
