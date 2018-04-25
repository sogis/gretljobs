SELECT a.gmde, a.bezirk, a.wkb_geometry, b.emiss_so2, b.emiss_nox, b.emiss_co, 
    b.emiss_ch4, b.emiss_pm10, b.emiss_nh3, b.emiss_nmvoc, b.emiss_co2, 
    b.emiss_n2o
   FROM ekat2015.gmde_geom a, 
    ( SELECT d.gem_bfs, sum(d.emiss_co) AS emiss_co, sum(d.emiss_co2) AS emiss_co2, 
            sum(d.emiss_nox) AS emiss_nox, sum(d.emiss_so2) AS emiss_so2, 
            sum(d.emiss_nmvoc) AS emiss_nmvoc, sum(d.emiss_ch4) AS emiss_ch4, 
            sum(d.emiss_pm10) AS emiss_pm10, sum(d.emiss_nh3) AS emiss_nh3, 
            sum(d.emiss_n2o) AS emiss_n2o
           FROM ekat2015.qg_land_forst d
          GROUP BY d.gem_bfs) b
  WHERE a.gmde = b.gem_bfs::numeric AND a.kt = 11::numeric
  ORDER BY a.gmde;
