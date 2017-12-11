 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    d.emiss_co + e.emiss_co + f.emiss_co + g.emiss_co + h.emiss_co + i.emiss_co AS emiss_co, 
    d.emiss_nox + e.emiss_nox + f.emiss_nox + g.emiss_nox + h.emiss_nox + i.emiss_nox AS emiss_nox, 
    d.emiss_n2o + e.emiss_n2o + f.emiss_n2o + g.emiss_n2o + h.emiss_n2o + i.emiss_n2o AS emiss_n2o, 
    d.emiss_pm10 + e.emiss_pm10 + f.emiss_pm10 + g.emiss_pm10 + h.emiss_pm10 + i.emiss_pm10 AS emiss_pm10, 
    d.emiss_co2 + e.emiss_co2 + f.emiss_co2 + g.emiss_co2 + h.emiss_co2 + i.emiss_co2 AS emiss_co2, 
    d.emiss_ch4 + e.emiss_ch4 + f.emiss_ch4 + g.emiss_ch4 + h.emiss_ch4 + i.emiss_ch4 AS emiss_ch4, 
    d.emiss_so2 + e.emiss_so2 + f.emiss_so2 + g.emiss_so2 + h.emiss_so2 + i.emiss_so2 AS emiss_so2, 
    h.emiss_nh3 + i.emiss_nh3 + j.emiss_nh3::double precision AS emiss_nh3, 
    h.emiss_nmvoc + i.emiss_nmvoc + j.emiss_nmvoc::double precision AS emiss_nmvoc
   FROM ekat2015.ug_feuer_eq_gas_nach93 d
   LEFT JOIN ekat2015.ug_feuer_eq_gas_vor93 e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_feuer_eq_oel_nach93 f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_feuer_eq_oel_vor93 g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_feuer_eq_holz_haus h ON g.xkoord = h.xkoord AND g.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_feuer_eq_holz_klein i ON h.xkoord = i.xkoord AND h.ykoord = i.ykoord
   LEFT JOIN ekat2015.ug_feuer_eq_alle_nmvoc_nh3 j ON i.xkoord = j.xkoord AND i.ykoord = j.ykoord
  ORDER BY d.xkoord, d.ykoord;
