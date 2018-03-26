SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN a.xkoord = d.xkoord::numeric AND a.ykoord = d.ykoord::numeric AND d.emiss_pm10 IS NOT NULL THEN d.emiss_pm10
            ELSE 0::numeric
        END AS emiss_pm10, 
        CASE
            WHEN a.xkoord = d.xkoord::numeric AND a.ykoord = d.ykoord::numeric AND d.emiss_nox IS NOT NULL THEN d.emiss_nox
            ELSE 0::numeric
        END AS emiss_nox
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT b.xkoord, b.ykoord, b.emiss_pm10, b.emiss_nox
           FROM ( SELECT bahn.ogc_fid, bahn.ogc_fid_ha, bahn.wkb_geometry, 
                    bahn.xkoord, bahn.ykoord, bahn.emiss_pm10, bahn.emiss_nox, 
                    bahn.new_date, bahn.archive_date, bahn.archive
                   FROM ekat2015.bahn
                  WHERE bahn.archive = 0) b
      LEFT JOIN ( SELECT tunnel.ogc_fid, tunnel.ogc_fid_ha, tunnel.wkb_geometry, 
                    tunnel.xkoord, tunnel.ykoord, tunnel.new_date, 
                    tunnel.archive_date, tunnel.archive
                   FROM ekat.tunnel
                  WHERE tunnel.archive = 0) c ON b.xkoord = c.xkoord AND b.ykoord = c.ykoord
     WHERE c.xkoord IS NULL AND c.ykoord IS NULL) d ON a.xkoord = d.xkoord::numeric AND a.ykoord = d.ykoord::numeric
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
