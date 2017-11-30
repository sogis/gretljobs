 SELECT a.gmde::integer AS gmde, a.wkb_geometry, b.emiss_nox
   FROM ekat2015.gmde_geom a, 
    ( SELECT d.gem_bfs, sum(d.emiss_nox) AS emiss_nox
           FROM ekat2015.ug_blitze d
          GROUP BY d.gem_bfs) b
  WHERE a.gmde = b.gem_bfs::numeric AND a.kt = 11::numeric
  ORDER BY a.gmde;
