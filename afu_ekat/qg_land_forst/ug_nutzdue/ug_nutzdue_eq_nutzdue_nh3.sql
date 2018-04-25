SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN b.emiss_nh3 IS NULL THEN 0::numeric::double precision
            ELSE b.emiss_nh3
        END AS emiss_nh3
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT a.xkoord, a.ykoord, sum(a.emiss_nh3) AS emiss_nh3
           FROM ( SELECT a.xkoord, a.ykoord, a.flaeche, 
                    a.flaeche::double precision * (m.emiss_nh3 / c.flaeche_betr::double precision) AS emiss_nh3
                   FROM ( SELECT dyn_stdort_radien.pid, 
                            dyn_stdort_radien.xkoord, dyn_stdort_radien.ykoord, 
                            dyn_stdort_radien.flaeche
                           FROM ekat2015.dyn_stdort_radien) a
              LEFT JOIN ( SELECT sum(dyn_stdort_radien.flaeche) AS flaeche_betr, xkoord, ykoord
                           FROM ekat2015.dyn_stdort_radien
                          GROUP BY xkoord, ykoord) c ON a.xkoord = c.xkoord AND a.ykoord = c.ykoord
         LEFT JOIN ( SELECT floor(x_koord/100)*100 AS x_koord, floor(y_koord/100)*100 AS y_koord, 
                       dynamo_nh3.pflanzenbau + coalesce(dynamo_nh3.recycl_duenger,0) AS emiss_nh3
                      FROM ekat2015.dynamo_nh3) m ON c.xkoord = m.x_koord AND c.ykoord = m.y_koord) a
          GROUP BY a.xkoord, a.ykoord) b ON a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
