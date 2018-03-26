SELECT a.gmde, a.wkb_geometry, b.emiss_pm10, b.emiss_nox
   FROM ekat.gmde_geom a, 
    ( SELECT d.gem_bfs, sum(d.emiss_pm10) AS emiss_pm10, 
            sum(d.emiss_nox) AS emiss_nox
           FROM ekat2015.ug_bahn_gesamt d
          GROUP BY d.gem_bfs) b
  WHERE a.gmde = b.gem_bfs AND a.kt = 11
  ORDER BY a.gmde;
