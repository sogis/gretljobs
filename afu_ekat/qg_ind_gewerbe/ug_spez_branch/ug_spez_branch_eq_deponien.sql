 SELECT min(k.ogc_fid) AS ogc_fid, min(k.xkoord) AS xkoord, 
    min(k.ykoord) AS ykoord, k.wkb_geometry, min(k.gem_bfs) AS gem_bfs, 
    sum(k.emiss_ch4) AS emiss_ch4
   FROM ( SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
                CASE
                    WHEN c.xkoord IS NOT NULL AND c.ykoord IS NOT NULL THEN ((( SELECT b.schast_emiss
                       FROM ekat2015.emiss_quelle a
                  LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
                 WHERE a.equelle_id = 131 AND b.s_code = 6 AND a.archive = 0 AND b.archive = 0))::numeric / e.flaeche_so::numeric * 1000::numeric)::double precision * c.flaeche
                    ELSE 0::numeric::double precision
                END AS emiss_ch4
           FROM ekat2015.ha_raster_100 a
      LEFT JOIN ( SELECT min(trunc(deponiestandorte.xkoord::numeric, (-2))) AS xkoord, 
                    min(trunc(deponiestandorte.ykoord::numeric, (-2))) AS ykoord, 
                    sum(deponiestandorte.flaeche) AS flaeche
                   FROM ekat2015.deponiestandorte
                  GROUP BY trunc(deponiestandorte.xkoord::numeric, (-2)), trunc(deponiestandorte.ykoord::numeric, (-2))) c ON a.xkoord = c.xkoord AND a.ykoord = c.ykoord, 
       ( SELECT sum(deponiestandorte.flaeche) AS flaeche_so
              FROM ekat2015.deponiestandorte) e) k
  GROUP BY k.wkb_geometry
  ORDER BY min(k.xkoord), min(k.ykoord);
