SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, d.vsit, 
    coalesce(d.emiss_co,0) + coalesce(e.emiss_co,0) + coalesce(f.emiss_co,0) + coalesce(g.emiss_co,0) + coalesce(i.emiss_co,0) AS emiss_co, 
    coalesce(d.emiss_co2,0) + coalesce(e.emiss_co2,0) + coalesce(f.emiss_co2,0) + coalesce(g.emiss_co2,0) + coalesce(i.emiss_co2,0) AS emiss_co2, 
    coalesce(d.emiss_nox,0) + coalesce(e.emiss_nox,0) + coalesce(f.emiss_nox,0) + coalesce(g.emiss_nox,0) + coalesce(i.emiss_nox,0) AS emiss_nox, 
    coalesce(d.emiss_so2,0) + coalesce(e.emiss_so2,0) + coalesce(f.emiss_so2,0) + coalesce(g.emiss_so2,0) + coalesce(i.emiss_so2,0) AS emiss_so2, 
    coalesce(d.emiss_nmvoc,0) + coalesce(e.emiss_nmvoc,0) + coalesce(f.emiss_nmvoc,0) + coalesce(g.emiss_nmvoc,0) + coalesce(i.emiss_nmvoc,0)
    + coalesce(n.emiss_nmvoc,0) + coalesce(o.emiss_nmvoc,0) + coalesce(p.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(d.emiss_ch4,0) + coalesce(e.emiss_ch4,0) + coalesce(f.emiss_ch4,0) + coalesce(g.emiss_ch4,0) + coalesce(i.emiss_ch4,0) AS emiss_ch4, 
    coalesce(d.emiss_nh3,0) + coalesce(e.emiss_nh3,0) + coalesce(f.emiss_nh3,0) + coalesce(g.emiss_nh3,0) + coalesce(i.emiss_nh3,0) AS emiss_nh3, 
    coalesce(d.emiss_n2o,0) + coalesce(e.emiss_n2o,0) + coalesce(f.emiss_n2o,0) + coalesce(g.emiss_n2o,0) + coalesce(i.emiss_n2o,0) AS emiss_n2o, 
    coalesce(d.emiss_pm10,0) + coalesce(e.emiss_pm10,0) + coalesce(f.emiss_pm10,0) + coalesce(g.emiss_pm10,0) + coalesce(i.emiss_pm10,0)
    + coalesce(j.emiss_pm10,0) + coalesce(k.emiss_pm10,0) + coalesce(l.emiss_pm10,0) + coalesce(m.emiss_pm10,0) AS emiss_pm10
   FROM ekat2015.ug_strkvk_eq_pw d
   JOIN ekat2015.ug_strkvk_eq_li e ON e.xkoord = d.xkoord AND e.ykoord = d.ykoord
   JOIN ekat2015.ug_strkvk_eq_mr f ON f.xkoord = e.xkoord AND f.ykoord = e.ykoord
   JOIN ekat2015.ug_strkvk_eq_snf g ON g.xkoord = f.xkoord AND g.ykoord = f.ykoord
   JOIN ekat2015.ug_strkvk_eq_rb i ON i.xkoord = g.xkoord AND i.ykoord = g.ykoord
   JOIN ekat2015.ug_strkvk_eq_aufw_abr_lmw j ON j.xkoord = i.xkoord AND j.ykoord = i.ykoord
   JOIN ekat2015.ug_strkvk_eq_aufw_abr_smw k ON k.xkoord = j.xkoord AND k.ykoord = j.ykoord
   JOIN ekat2015.ug_strkvk_eq_aufw_abr_mr_2t l ON l.xkoord = k.xkoord AND l.ykoord = k.ykoord
   JOIN ekat2015.ug_strkvk_eq_aufw_abr_mr_4t m ON m.xkoord = l.xkoord AND m.ykoord = l.ykoord
   JOIN ekat2015.ug_strkvk_eq_running_losses_li n ON n.xkoord = m.xkoord AND n.ykoord = m.ykoord
   JOIN ekat2015.ug_strkvk_eq_running_losses_pw o ON m.xkoord = o.xkoord AND m.ykoord = o.ykoord
   JOIN ekat2015.ug_strkvk_eq_running_losses_mr p ON o.xkoord = p.xkoord AND o.ykoord = p.ykoord
  ORDER BY d.xkoord, d.ykoord;
