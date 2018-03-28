SELECT min(k.ogc_fid) AS ogc_fid, min(k.xkoord) AS xkoord, 
    min(k.ykoord) AS ykoord, k.wkb_geometry, min(k.gem_bfs) AS gem_bfs, 
    sum(k.emiss_pm10) AS emiss_pm10
   FROM ( SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
                CASE
                    WHEN c.ioaoab::text = 'AO'::text THEN (b.dtv2015_snf + b.dtv2015_rb)::double precision * (( SELECT b.schast_efak
                       FROM ekat2015.emiss_quelle a
                  LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
                 WHERE a.equelle_id = 46 AND b.s_code = 7 ))::double precision * 365::double precision
                    WHEN c.ioaoab::text = 'IO'::text THEN (b.dtv2015_snf + b.dtv2015_rb)::double precision * (( SELECT b.schast_efak
                       FROM ekat2015.emiss_quelle a
                  LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
                 WHERE a.equelle_id = 47 AND b.s_code = 7 ))::double precision * 365::double precision
                    WHEN c.ioaoab::text = 'AB'::text THEN (b.dtv2015_snf + b.dtv2015_rb)::double precision * (( SELECT b.schast_efak
                       FROM ekat2015.emiss_quelle a
                  LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
                 WHERE a.equelle_id = 45 AND b.s_code = 7 ))::double precision * 365::double precision
                    ELSE 0::double precision
                END AS emiss_pm10
           FROM ekat2015.ha_raster_100 a
      LEFT JOIN ( SELECT intersec_link2015_ha_raster.ogc_fid, 
                    intersec_link2015_ha_raster.gid_link, 
                    intersec_link2015_ha_raster.ogc_fid_ha, 
                    intersec_link2015_ha_raster.xkoord, 
                    intersec_link2015_ha_raster.ykoord, 
                    intersec_link2015_ha_raster.gem_bfs, 
                    intersec_link2015_ha_raster.laenge, 
                    intersec_link2015_ha_raster.laenge_neu, 
                    intersec_link2015_ha_raster.dtv2015_pw, 
                    intersec_link2015_ha_raster.dtv2015_li, 
                    intersec_link2015_ha_raster.dtv2015_mr, 
                    intersec_link2015_ha_raster.dtv2015_snf, 
                    intersec_link2015_ha_raster.dtv2015_rb, 
                    intersec_link2015_ha_raster.wkb_geometry
                   FROM ekat2015.intersec_link2015_ha_raster) b ON a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric
   LEFT JOIN ( SELECT f.wkb_geometry, f.gid, 
               f."LAENGE" AS laenge, f."NEIGUNG" as neigung, f."NEIGUNG_BE" as neigung_be, f."TYPENO" as strassenty, 
               f."IOAOAB" AS ioaoab
              FROM verkehrsmodell2015.gvm_so_2015_meteotest f) c ON b.gid_link = c.gid
  WHERE a.archive = 0) k
  GROUP BY k.wkb_geometry
  ORDER BY min(k.xkoord), min(k.ykoord);
