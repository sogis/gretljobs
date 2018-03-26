SELECT a.gmde, a.wkb_geometry, b.emiss_pm10, b.emiss_co2, b.emiss_so2, 
    b.emiss_nox, b.emiss_nmvoc, b.emiss_co
   FROM ekat2015.gmde_geom a, 
    ( SELECT d.gem_bfs, sum(d.emiss_pm10) AS emiss_pm10, 
            sum(d.emiss_co2) AS emiss_co2, sum(d.emiss_so2) AS emiss_so2, 
            sum(d.emiss_nox) AS emiss_nox, sum(d.emiss_nmvoc) AS emiss_nmvoc, 
            sum(d.emiss_co) AS emiss_co
           FROM ekat2015.ug_flug_gesamt d
          GROUP BY d.gem_bfs) b
  WHERE a.gmde = b.gem_bfs::numeric AND a.kt = 11::numeric
  ORDER BY a.gmde;
