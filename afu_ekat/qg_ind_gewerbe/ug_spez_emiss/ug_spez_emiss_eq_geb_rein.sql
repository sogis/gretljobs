 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN f.besch_gesamt > 0 THEN (( SELECT e.schast_emiss
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.equelle_id = 35 AND e.s_code = 22 AND d.archive = 0 AND e.archive = 0)) / b.besch_gesamt::double precision * f.besch_gesamt::numeric::double precision * 1000::double precision
            ELSE 0::numeric::double precision
        END AS emiss_nmvoc
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT besch_gesamt, x, y FROM ekat2015.bz_besch_2_und3_sektor) f ON a.xkoord = f.x::numeric AND a.ykoord = f.y::numeric, 
    ( SELECT sum(besch_gesamt) AS besch_gesamt 
      FROM ekat2015.bz_besch_2_und3_sektor) b
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;
