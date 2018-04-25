 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN b.emiss_nh3 IS NULL THEN 0::numeric::double precision
            ELSE b.emiss_nh3
        END AS emiss_nh3, 
        CASE
            WHEN b.emiss_n2o IS NULL THEN 0::numeric
            ELSE b.emiss_n2o
        END AS emiss_n2o
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT a.xkoord, a.ykoord, sum(a.flaeche) AS flaeche, 
            sum(a.emiss_nh3) AS emiss_nh3, sum(a.emiss_n2o) AS emiss_n2o
           FROM ( SELECT a.pid, a.xkoord, a.ykoord, a.flaeche, 
                    a.flaeche::double precision * (b.emiss_nh3 / c.flaeche_betr::double precision) AS emiss_nh3, 
                    a.flaeche * (b.emiss_n2o / c.flaeche_betr) AS emiss_n2o
                   FROM ( SELECT dyn_stdort_radien.pid, 
                            dyn_stdort_radien.xkoord, dyn_stdort_radien.ykoord, 
                            dyn_stdort_radien.flaeche
                           FROM ekat2015.dyn_stdort_radien) a
              LEFT JOIN ( SELECT dyn_stdort_radien.pid, 
                            sum(dyn_stdort_radien.flaeche) AS flaeche_betr
                           FROM ekat2015.dyn_stdort_radien
                          GROUP BY dyn_stdort_radien.pid) c ON a.pid = c.pid
         LEFT JOIN ( SELECT dynamo_nh3.pid, 
                       dynamo_nh3.hofduenger_transfer AS emiss_nh3, 
                       dynamo_nh3.hofdue_transfer AS emiss_n2o
                      FROM ekat2015.dynamo_nh3) b ON a.pid = b.pid) a
          GROUP BY a.xkoord, a.ykoord) b ON a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric
  WHERE a.archive = 0
  ORDER BY a.xkoord, b.xkoord;
