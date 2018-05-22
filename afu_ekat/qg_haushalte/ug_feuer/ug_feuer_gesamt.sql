 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(d.emiss_co,0) + coalesce(e.emiss_co,0) + coalesce(f.emiss_co,0) + coalesce(g.emiss_co,0) + coalesce(h.emiss_co,0) + coalesce(i.emiss_co,0) AS emiss_co, 
    coalesce(d.emiss_nox,0) + coalesce(e.emiss_nox,0) + coalesce(f.emiss_nox,0) + coalesce(g.emiss_nox,0) + coalesce(h.emiss_nox,0) + coalesce(i.emiss_nox,0) AS emiss_nox, 
    coalesce(d.emiss_n2o,0) + coalesce(e.emiss_n2o,0) + coalesce(f.emiss_n2o,0) + coalesce(g.emiss_n2o,0) + coalesce(h.emiss_n2o,0) + coalesce(i.emiss_n2o,0) AS emiss_n2o, 
    coalesce(d.emiss_pm10,0) + coalesce(e.emiss_pm10,0) + coalesce(f.emiss_pm10,0) + coalesce(g.emiss_pm10,0) + coalesce(h.emiss_pm10,0) + coalesce(i.emiss_pm10,0) AS emiss_pm10, 
    coalesce(d.emiss_co2,0) + coalesce(e.emiss_co2,0) + coalesce(f.emiss_co2,0) + coalesce(g.emiss_co2,0) + coalesce(h.emiss_co2,0) + coalesce(i.emiss_co2,0) AS emiss_co2, 
    coalesce(d.emiss_ch4,0) + coalesce(e.emiss_ch4,0) + coalesce(f.emiss_ch4,0) + coalesce(g.emiss_ch4,0) + coalesce(h.emiss_ch4,0) + coalesce(i.emiss_ch4,0) AS emiss_ch4, 
    coalesce(d.emiss_so2,0) + coalesce(e.emiss_so2,0) + coalesce(f.emiss_so2,0) + coalesce(g.emiss_so2,0) + coalesce(h.emiss_so2,0) + coalesce(i.emiss_so2,0) AS emiss_so2, 
    coalesce(h.emiss_nh3,0) + coalesce(i.emiss_nh3,0) + coalesce(j.emiss_nh3,0) AS emiss_nh3, 
    coalesce(h.emiss_nmvoc,0) + coalesce(i.emiss_nmvoc,0) + coalesce(j.emiss_nmvoc,0) AS emiss_nmvoc
   FROM ekat2015.ug_feuer_eq_gas_nach93 d
   LEFT JOIN ekat2015.ug_feuer_eq_gas_vor93 e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_feuer_eq_oel_nach93 f ON e.xkoord = f.xkoord AND e.ykoord = f.ykoord
   LEFT JOIN ekat2015.ug_feuer_eq_oel_vor93 g ON f.xkoord = g.xkoord AND f.ykoord = g.ykoord
   LEFT JOIN ekat2015.ug_feuer_eq_holz_haus h ON g.xkoord = h.xkoord AND g.ykoord = h.ykoord
   LEFT JOIN ekat2015.ug_feuer_eq_holz_klein i ON h.xkoord = i.xkoord AND h.ykoord = i.ykoord
   LEFT JOIN ekat2015.ug_feuer_eq_alle_nmvoc_nh3 j ON i.xkoord = j.xkoord AND i.ykoord = j.ykoord
  ORDER BY d.xkoord, d.ykoord;
