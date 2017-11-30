 SELECT c.ogc_fid, c.xkoord, c.ykoord, c.wkb_geometry, c.gem_bfs, 
    b.schast_efak AS emiss_nox
   FROM ekat2015.quelle_emiss_efak b, 
    ( SELECT ha_raster_100.ogc_fid, ha_raster_100.wkb_geometry, 
            ha_raster_100.xkoord, ha_raster_100.ykoord, ha_raster_100.gem_bfs, 
            ha_raster_100.new_date, 
            ha_raster_100.archive_date, ha_raster_100.archive
           FROM ekat2015.ha_raster_100
          WHERE ha_raster_100.archive = 0) c
  WHERE b.equelle_id = 65 AND b.archive = 0
  ORDER BY c.xkoord, c.ykoord;
