 SELECT a.gmde, a.wkb_geometry, b.emiss_nox, b.emiss_ch4, b.emiss_n2o
   FROM ekat2015.gmde_geom a, 
    ( SELECT d.gem_bfs, sum(d.emiss_nox + e.emiss_nox + f.emiss_nox) AS emiss_nox, 
            sum(d.emiss_ch4 + e.emiss_ch4 + f.emiss_ch4) AS emiss_ch4, 
            sum(d.emiss_n2o + e.emiss_n2o + f.emiss_n2o) AS emiss_n2o
           FROM ekat2015.ug_gewaesser_eq_seen d
      LEFT JOIN ekat2015.ug_gewaesser_eq_fluesse e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
   LEFT JOIN ekat2015.ug_gewaesser_eq_feuchtgebiete f ON d.xkoord = f.xkoord AND d.ykoord = f.ykoord
  GROUP BY d.gem_bfs) b
  WHERE a.gmde = b.gem_bfs::numeric AND a.kt = 11::numeric
  ORDER BY a.gmde;
