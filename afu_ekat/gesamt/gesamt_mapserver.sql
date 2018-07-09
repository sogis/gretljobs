SELECT a.ogc_fid,a.xkoord,a.ykoord,a.wkb_geometry,a.gem_bfs,
coalesce(a.emiss_co,0) + coalesce(b.emiss_co,0) + coalesce(c.emiss_co,0) + coalesce(d.emiss_co,0) + coalesce(e.emiss_co,0) AS emiss_co, 
coalesce(a.emiss_nox,0) + coalesce(b.emiss_nox,0) + coalesce(c.emiss_nox,0) + coalesce(d.emiss_nox,0) + coalesce(e.emiss_nox,0) AS emiss_nox, 
coalesce(a.emiss_so2,0) + coalesce(b.emiss_so2,0) + coalesce(c.emiss_so2,0) + coalesce(d.emiss_so2,0) + coalesce(e.emiss_so2,0) AS emiss_so2, 
coalesce(a.emiss_nmvoc,0) + coalesce(b.emiss_nmvoc,0) +  coalesce(c.emiss_nmvoc,0) + coalesce(d.emiss_nmvoc,0) + coalesce(e.emiss_nmvoc,0) AS emiss_nmvoc,
coalesce(a.emiss_pm10,0) + coalesce(b.emiss_pm10,0) + coalesce(c.emiss_pm10,0) + coalesce(d.emiss_pm10,0) + coalesce(e.emiss_pm10,0) AS emiss_pm10,
coalesce(a.emiss_nh3,0) + coalesce(b.emiss_nh3,0) + coalesce(c.emiss_nh3,0) + coalesce(d.emiss_nh3,0) + coalesce(e.emiss_nh3,0) as emiss_nh3,
coalesce(a.emiss_xkw,0) + coalesce(b.emiss_xkw,0) + coalesce(c.emiss_xkw,0) + coalesce(d.emiss_xkw,0) + coalesce(e.emiss_xkw,0) as emiss_xkw,
coalesce(a.emiss_co2,0) + coalesce(b.emiss_co2,0) + coalesce(c.emiss_co2,0) + coalesce(d.emiss_co2,0) + coalesce(e.emiss_co2,0) as emiss_co2,
coalesce(a.emiss_ch4,0) + coalesce(b.emiss_ch4,0) + coalesce(c.emiss_ch4,0) + coalesce(d.emiss_ch4,0) + coalesce(e.emiss_ch4,0) AS emiss_ch4,  
coalesce(a.emiss_n2o,0) + coalesce(b.emiss_n2o,0) + coalesce(c.emiss_n2o,0) + coalesce(d.emiss_n2o,0) + coalesce(e.emiss_n2o,0) AS emiss_n2o
FROM ekat2015.ind_gewerbe_mapserver a
LEFT JOIN ekat2015.haushalte_mapserver b ON a.xkoord = b.xkoord and a.ykoord = b.ykoord
LEFT JOIN ekat2015.verkehr_mapserver c ON b.xkoord = c.xkoord and b.ykoord = c.ykoord
LEFT JOIN ekat2015.land_forst_mapserver d ON c.xkoord = d.xkoord and c.ykoord = d.ykoord
LEFT JOIN ekat2015.biogene_quellen_mapserver e ON d.xkoord = e.xkoord and d.ykoord = e.ykoord;
