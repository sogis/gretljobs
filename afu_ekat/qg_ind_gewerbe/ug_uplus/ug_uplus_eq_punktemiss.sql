 SELECT min(e.ogc_fid) AS ogc_fid, min(e.xkoord) AS xkoord, 
    min(e.ykoord) AS ykoord, e.wkb_geometry, min(e.gem_bfs) AS gem_bfs, 
    sum(e.emiss_co) AS emiss_co, sum(e.emiss_co2) AS emiss_co2, 
    sum(e.emiss_nox) AS emiss_nox, sum(e.emiss_so2) AS emiss_so2, 
    sum(e.emiss_nmvoc) AS emiss_nmvoc, sum(e.emiss_ch4) AS emiss_ch4, 
    sum(e.emiss_pm10) AS emiss_pm10, sum(e.emiss_nh3) AS emiss_nh3, 
    sum(e.emiss_n2o) AS emiss_n2o, sum(e.emiss_xkw) AS emiss_xkw
   FROM ( SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
            b.corinaircd, 
                CASE
                    WHEN b.schast::text = 'CO'::text THEN b.emiss
                    ELSE 0::numeric
                END AS emiss_co, 
                CASE
                    WHEN b.schast::text = 'CO2'::text THEN b.emiss
                    ELSE 0::numeric
                END AS emiss_co2, 
                CASE
                    WHEN b.schast::text = 'NO2'::text THEN b.emiss
                    ELSE 0::numeric
                END AS emiss_nox, 
                CASE
                    WHEN b.schast::text = 'SO2'::text THEN b.emiss
                    ELSE 0::numeric
                END AS emiss_so2, 
                CASE
                    WHEN b.schast::text <> 'VOC'::text OR b.schast IS NULL THEN 0::numeric
                    WHEN b.schast::text = 'VOC'::text AND (b.schast_nr = 1 OR b.schast_nr = 2 OR b.schast_nr = 5 OR b.schast_nr = 6 OR b.schast_nr = 7 OR b.schast_nr = 8 OR b.schast_nr = 9 OR b.schast_nr = 10 OR b.schast_nr = 11 OR b.schast_nr = 12 OR b.schast_nr = 13 OR b.schast_nr = 14 OR b.schast_nr = 15 OR b.schast_nr = 16 OR b.schast_nr = 17 OR b.schast_nr = 20 OR b.schast_nr = 27 OR b.schast_nr = 32 OR b.schast_nr = 40 OR b.schast_nr = 41 OR b.schast_nr = 50 OR b.schast_nr = 51 OR b.schast_nr = 57 OR b.schast_nr = 58 OR b.schast_nr = 62 OR b.schast_nr = 86 OR b.schast_nr = 87 OR b.schast_nr = 88 OR b.schast_nr = 89 OR b.schast_nr = 90 OR b.schast_nr = 91 OR b.schast_nr = 99 OR b.schast_nr = 100 OR b.schast_nr = 101 OR b.schast_nr = 182 OR b.schast_nr = 183 OR b.schast_nr = 190 OR b.schast_nr = 191 OR b.schast_nr = 192 OR b.schast_nr = 193 OR b.schast_nr = 194 OR b.schast_nr = 197 OR b.schast_nr = 200 OR b.schast_nr = 211 OR b.schast_nr = 223 OR b.schast_nr = 225 OR b.schast_nr = 280 OR b.schast_nr = 2073) THEN 0::numeric
                    ELSE b.emiss
                END AS emiss_nmvoc, 
                CASE
                    WHEN b.schast::text = 'CH4'::text THEN b.emiss
                    ELSE 0::numeric
                END AS emiss_ch4, 
                CASE
                    WHEN b.schast::text = 'PM10'::text THEN b.emiss
                    ELSE 0::numeric
                END AS emiss_pm10, 
                CASE
                    WHEN b.schast::text = 'NH3'::text THEN b.emiss
                    ELSE 0::numeric
                END AS emiss_nh3, 
                CASE
                    WHEN b.schast::text = 'N2O'::text THEN b.emiss
                    ELSE 0::numeric
                END AS emiss_n2o, 
                CASE
                    WHEN b.schast::text = 'VOC'::text AND (b.schast_nr = 1 OR b.schast_nr = 2 OR b.schast_nr = 5 OR b.schast_nr = 6 OR b.schast_nr = 7 OR b.schast_nr = 8 OR b.schast_nr = 9 OR b.schast_nr = 10 OR b.schast_nr = 11 OR b.schast_nr = 12 OR b.schast_nr = 13 OR b.schast_nr = 14 OR b.schast_nr = 15 OR b.schast_nr = 16 OR b.schast_nr = 17 OR b.schast_nr = 20 OR b.schast_nr = 27 OR b.schast_nr = 32 OR b.schast_nr = 40 OR b.schast_nr = 41 OR b.schast_nr = 50 OR b.schast_nr = 51 OR b.schast_nr = 57 OR b.schast_nr = 58 OR b.schast_nr = 62 OR b.schast_nr = 86 OR b.schast_nr = 87 OR b.schast_nr = 88 OR b.schast_nr = 89 OR b.schast_nr = 90 OR b.schast_nr = 91 OR b.schast_nr = 99 OR b.schast_nr = 100 OR b.schast_nr = 101 OR b.schast_nr = 182 OR b.schast_nr = 183 OR b.schast_nr = 190 OR b.schast_nr = 191 OR b.schast_nr = 192 OR b.schast_nr = 193 OR b.schast_nr = 194 OR b.schast_nr = 197 OR b.schast_nr = 200 OR b.schast_nr = 211 OR b.schast_nr = 223 OR b.schast_nr = 225 OR b.schast_nr = 280 OR b.schast_nr = 2073) THEN b.emiss
                    ELSE 0::numeric
                END AS emiss_xkw
           FROM ekat2015.ha_raster_100 a
      LEFT JOIN ( SELECT a.xkoord, a.ykoord, a.emiss, a.schast, a.schast_nr, 
                    a.corinaircd, a.anldatid
                   FROM ( SELECT trunc(uplus_20140526.anlkoordxf, (-2)) AS xkoord, 
                            trunc(uplus_20140526.anlkoordyf, (-2)) AS ykoord, 
                            uplus_20140526.emifrachtmsggf AS emiss, 
                            uplus_20140526.emidsotyps AS schast, 
                            uplus_20140526.emidsoid AS schast_nr, 
                            uplus_20140526.anldatid, 
                                CASE
                                    WHEN uplus_20140526.corinaircd IS NULL THEN 'keine vorhanden'::character varying
                                    ELSE uplus_20140526.corinaircd
                                END AS corinaircd
                           FROM ekat2015.uplus uplus_20140526) a
                  WHERE a.corinaircd::text <> 'Metallreinigung'::text AND a.corinaircd::text <> 'Lachgasanwendung Spitäler'::text AND a.corinaircd::text <> 'Farbanwendung Bau'::text AND a.anldatid <> 324) b ON a.xkoord = b.xkoord AND a.ykoord = b.ykoord
     WHERE a.archive = 0) e
  GROUP BY e.wkb_geometry
  ORDER BY min(e.xkoord), min(e.ykoord);
