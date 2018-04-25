SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN a.xkoord = c.xkoord AND a.ykoord = c.ykoord THEN c.area * (d.emiss_pm10::double precision / (pi() * 15::double precision * 3::double precision * 100::double precision))::numeric
            ELSE 0::numeric
        END AS emiss_pm10, 
        CASE
            WHEN a.xkoord = c.xkoord AND a.ykoord = c.ykoord THEN c.area * (d.emiss_co2::double precision / (pi() * 15::double precision * 3::double precision * 100::double precision))::numeric
            ELSE 0::numeric
        END AS emiss_co2, 
        CASE
            WHEN a.xkoord = c.xkoord AND a.ykoord = c.ykoord THEN c.area * (d.emiss_so2::double precision / (pi() * 15::double precision * 3::double precision * 100::double precision))::numeric
            ELSE 0::numeric
        END AS emiss_so2, 
        CASE
            WHEN a.xkoord = c.xkoord AND a.ykoord = c.ykoord THEN c.area * (d.emiss_nox::double precision / (pi() * 15::double precision * 3::double precision * 100::double precision))::numeric
            ELSE 0::numeric
        END AS emiss_nox, 
        CASE
            WHEN a.xkoord = c.xkoord AND a.ykoord = c.ykoord THEN c.area * (d.emiss_nmvoc::double precision / (pi() * 15::double precision * 3::double precision * 100::double precision))::numeric
            ELSE 0::numeric
        END AS emiss_nmvoc, 
        CASE
            WHEN a.xkoord = c.xkoord AND a.ykoord = c.ykoord THEN c.area * (d.emiss_co::double precision / (pi() * 15::double precision * 3::double precision * 100::double precision))::numeric
            ELSE 0::numeric
        END AS emiss_co
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT b.ogc_fid, b.xkoord, b.ykoord, b.area, b.wkb_geometry, 
            b.new_date, b.archive_date, b.archive
           FROM ekat.flug_geb_ha b
          WHERE b.archive = 0) c ON a.xkoord = c.xkoord AND a.ykoord = c.ykoord, 
    ( SELECT flug_emiss.fid, flug_emiss.unterteilung, flug_emiss.emiss_pm10, 
       flug_emiss.emiss_co2, flug_emiss.emiss_so2, flug_emiss.emiss_nox, 
       flug_emiss.emiss_nmvoc, flug_emiss.emiss_co, flug_emiss.new_date, 
       flug_emiss.archive_date, flug_emiss.archive
      FROM ekat2015.flug_emiss
     WHERE flug_emiss.archive = 0 AND flug_emiss.unterteilung = '3'::text) d
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
