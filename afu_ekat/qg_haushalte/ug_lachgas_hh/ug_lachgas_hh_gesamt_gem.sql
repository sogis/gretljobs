 SELECT a.gmde, a.wkb_geometry, b.emiss_n2o
   FROM ekat2015.gmde_geom a, 
    ( SELECT d.gem_bfs, sum(d.emiss_n2o) AS emiss_n2o
           FROM ekat2015.ug_lachgas_hh_gesamt d
          GROUP BY d.gem_bfs) b
  WHERE a.gmde = b.gem_bfs::numeric AND a.kt = 11::numeric
  ORDER BY a.gmde;
