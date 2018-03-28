SELECT min(k.ogc_fid) AS ogc_fid, min(k.xkoord) AS xkoord, min(k.ykoord) AS ykoord, 
    k.wkb_geometry, min(k.gem_bfs) AS gem_bfs, 
    sum(k.emiss_nmvoc) AS emiss_nmvoc
   FROM ( SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
                CASE
                    WHEN a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric THEN b.dtv2015_pw * (0.3333333 * ((( SELECT efak_kalt_tank.efak
                       FROM ekat2015.efak_kalt_tank
                      WHERE efak_kalt_tank.efak_code = 2 AND efak_kalt_tank.fhz_art = 'PKW'::text))::numeric * d.anz_pw::numeric * 365::numeric) / 1000::numeric / c.dtv2015_pw_gem)
                    ELSE 0::numeric
                END AS emiss_nmvoc
           FROM ekat2015.ha_raster_100 a
      LEFT JOIN ( SELECT intersec_link2015_ha_raster.ogc_fid, 
                    intersec_link2015_ha_raster.xkoord, 
                    intersec_link2015_ha_raster.ykoord, 
                    intersec_link2015_ha_raster.gem_bfs, 
                    intersec_link2015_ha_raster.dtv2015_pw
                   FROM ekat2015.intersec_link2015_ha_raster) b ON a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric
   LEFT JOIN ( SELECT intersec_link2015_ha_raster.gem_bfs, 
               sum(intersec_link2015_ha_raster.dtv2015_pw) AS dtv2015_pw_gem
              FROM ekat2015.intersec_link2015_ha_raster
             GROUP BY intersec_link2015_ha_raster.gem_bfs) c ON b.gem_bfs = c.gem_bfs
   LEFT JOIN ( SELECT gmde.gem_bfs, gmde.anz_pw
         FROM ekat2015.gmde
        WHERE gmde.archive = 0 AND gmde.gem_bfs >= 2401 AND gmde.gem_bfs <= 2622) d ON c.gem_bfs = d.gem_bfs
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord) k
  GROUP BY k.wkb_geometry
  ORDER BY min(k.xkoord), min(k.ykoord);
