SELECT min(k.ogc_fid) AS ogc_fid, min(k.xkoord) AS xkoord, 
    min(k.ykoord) AS ykoord, k.wkb_geometry, min(k.gem_bfs) AS gem_bfs, 
    sum(k.emiss_nmvoc) AS emiss_nmvoc
   FROM ( SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
                CASE
                    WHEN c.ioaoab::text = 'AO'::text THEN b.dtv_mr::double precision * (( SELECT b.schast_efak
                       FROM ekat2015.emiss_quelle a
                  LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
                 WHERE a.equelle_id = 220 AND b.s_code = 22 AND a.archive = 0 AND b.archive = 0))::double precision * 365::double precision
                    WHEN c.ioaoab::text = 'IO'::text THEN b.dtv_mr::double precision * (( SELECT b.schast_efak
                       FROM ekat2015.emiss_quelle a
                  LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
                 WHERE a.equelle_id = 221 AND b.s_code = 22 AND a.archive = 0 AND b.archive = 0))::double precision * 365::double precision
                    WHEN c.ioaoab::text = 'AB'::text THEN b.dtv_mr::double precision * (( SELECT b.schast_efak
                       FROM ekat2015.emiss_quelle a
                  LEFT JOIN ekat2015.quelle_emiss_efak b ON a.equelle_id = b.equelle_id
                 WHERE a.equelle_id = 219 AND b.s_code = 22 AND a.archive = 0 AND b.archive = 0))::double precision * 365::double precision
                    ELSE 0::double precision
                END AS emiss_nmvoc
           FROM ekat2015.ha_raster_100 a
      LEFT JOIN ( SELECT intersec_link_ha_raster.ogc_fid, 
                    intersec_link_ha_raster.gid_link, 
                    intersec_link_ha_raster.ogc_fid_ha, 
                    intersec_link_ha_raster.xkoord, 
                    intersec_link_ha_raster.ykoord, 
                    intersec_link_ha_raster.gem_bfs, 
                    intersec_link_ha_raster.laenge, 
                    intersec_link_ha_raster.laenge_neu, 
                    intersec_link_ha_raster.dtv_pw, 
                    intersec_link_ha_raster.dtv_snf, 
                    intersec_link_ha_raster.dtv_li, 
                    intersec_link_ha_raster.dtv_mr, 
                    intersec_link_ha_raster.dtv_rb, 
                    intersec_link_ha_raster.dtv_lb, 
                    intersec_link_ha_raster.ant_los1, 
                    intersec_link_ha_raster.ant_los2, 
                    intersec_link_ha_raster.ant_los3, 
                    intersec_link_ha_raster.ant_los4, 
                    intersec_link_ha_raster.neigung, 
                    intersec_link_ha_raster.vsit, 
                    intersec_link_ha_raster.wkb_geometry, 
                    intersec_link_ha_raster.new_date, 
                    intersec_link_ha_raster.archive_date, 
                    intersec_link_ha_raster.archive
                   FROM ekat2015.intersec_link_ha_raster
                  WHERE intersec_link_ha_raster.archive = 0) b ON a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric
   LEFT JOIN ( SELECT f.ogc_fid, f.wkb_geometry, f.objectid, f.linkno, 
               f.herkunft, f.laenge_alt, f.neigung, f.neigung_be, f.strassenty, 
               f.geschw, f.auslastung, f.auslastu_1, f.dtv_pw, f.dtv_snf, 
               f.dtv_li, f.dtv_mr, f.dtv_rb, f.dtv_lb, f.gis, f.tunnel, 
               f.bem_10_2, f.lsa_10, f.laenge_neu, f.vsit, f.pwe_10, f.mt_id, 
               f.kapazitaet, f.ausl_h_max, f.ant_los1, f.ant_los2, f.ant_los3, 
               f.ant_los4, f.shape_leng, f.ioaoab, f.new_date, f.archive_date, 
               f.archive
              FROM verkehrsmodell2015.gvm_so_2015_meteotest f
             WHERE f.archive = 0) c ON b.gid_link = c.ogc_fid
  WHERE a.archive = 0) k
  GROUP BY k.wkb_geometry
  ORDER BY min(k.xkoord), min(k.ykoord);
