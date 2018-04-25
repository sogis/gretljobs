 SELECT a.gmde, a.wkb_geometry, b.emiss_nh3, b.emiss_pm10, b.emiss_ch4, 
    b.emiss_n2o, b.emiss_nox
   FROM ekat2015.gmde_geom a, 
    ( SELECT d.gem_bfs, sum(d.emiss_nh3) AS emiss_nh3, 
            sum(d.emiss_pm10) AS emiss_pm10, sum(d.emiss_ch4) AS emiss_ch4, 
            sum(d.emiss_n2o) AS emiss_n2o, sum(d.emiss_nox) AS emiss_nox
           FROM ekat2015.ug_nutztier_gesamt d
          GROUP BY d.gem_bfs) b
  WHERE a.gmde = b.gem_bfs::numeric AND a.kt = 11::numeric
  ORDER BY a.gmde;
