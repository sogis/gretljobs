SELECT a.gmde::integer,a.bezirk,a.wkb_geometry,
a.emiss_co + b.emiss_co + c.emiss_co + d.emiss_co + e.emiss_co AS emiss_co,
a.emiss_nox + b.emiss_nox + c.emiss_nox + d.emiss_nox + e.emiss_nox AS emiss_nox,
a.emiss_so2 + b.emiss_so2 + c.emiss_so2 + d.emiss_so2 + e.emiss_so2 AS emiss_so2,  
 a.emiss_nmvoc + b.emiss_nmvoc +  c.emiss_nmvoc + d.emiss_nmvoc + e.emiss_nmvoc AS emiss_nmvoc,
a.emiss_pm10 + b.emiss_pm10 + c.emiss_pm10 + d.emiss_pm10 + e.emiss_pm10 AS emiss_pm10,
a.emiss_nh3 + b.emiss_nh3 + c.emiss_nh3 + d.emiss_nh3 + e.emiss_nh3 as emiss_nh3,
a.emiss_xkw + b.emiss_xkw + c.emiss_xkw + d.emiss_xkw + e.emiss_xkw as emiss_xkw,
a.emiss_co2 + b.emiss_co2 + c.emiss_co2 + d.emiss_co2 + e.emiss_co2 as emiss_co2, 
a.emiss_ch4 + b.emiss_ch4 + c.emiss_ch4 + d.emiss_ch4 + e.emiss_ch4 AS emiss_ch4, 
a.emiss_n2o + b.emiss_n2o + c.emiss_n2o + d.emiss_n2o + e.emiss_n2o AS emiss_n2o
FROM ekat2015.ind_gewerbe_gem_mapserver a
LEFT JOIN ekat2015.haushalte_gem_mapserver b ON a.gmde = b.gmde
LEFT JOIN ekat2015.verkehr_gem_mapserver c ON b.gmde = c.gmde
LEFT JOIN ekat2015.land_forst_gem_mapserver d ON c.gmde = d.gmde
LEFT JOIN ekat2015.biogene_quellen_gem_mapserver e ON d.gmde = e.gmde;
