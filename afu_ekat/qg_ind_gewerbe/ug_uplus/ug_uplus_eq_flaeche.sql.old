 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN b.emiss_co IS NOT NULL THEN b.emiss_co
            ELSE 0::numeric
        END AS emiss_co, 
        CASE
            WHEN b.emiss_co2 IS NOT NULL THEN b.emiss_co2
            ELSE 0::numeric
        END AS emiss_co2, 
        CASE
            WHEN b.emiss_nox IS NOT NULL THEN b.emiss_nox
            ELSE 0::numeric
        END AS emiss_nox, 
        CASE
            WHEN b.emiss_so2 IS NOT NULL THEN b.emiss_so2
            ELSE 0::numeric
        END AS emiss_so2, 
        CASE
            WHEN b.emiss_nmvoc IS NOT NULL THEN b.emiss_nmvoc
            ELSE 0::numeric
        END AS emiss_nmvoc, 
        CASE
            WHEN b.emiss_ch4 IS NOT NULL THEN b.emiss_ch4
            ELSE 0::numeric
        END AS emiss_ch4, 
        CASE
            WHEN b.emiss_pm10 IS NOT NULL THEN b.emiss_pm10
            ELSE 0::numeric
        END AS emiss_pm10, 
        CASE
            WHEN b.emiss_nh3 IS NOT NULL THEN b.emiss_nh3
            ELSE 0::numeric
        END AS emiss_nh3, 
        CASE
            WHEN b.emiss_n2o IS NOT NULL THEN b.emiss_n2o
            ELSE 0::numeric
        END AS emiss_n2o, 
        CASE
            WHEN b.emiss_xkw IS NOT NULL THEN b.emiss_xkw
            ELSE 0::numeric
        END AS emiss_xkw
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT min(intersec_bdbed_wohnzone_industrie_landw_ha_raster.art) AS art, 
            intersec_bdbed_wohnzone_industrie_landw_ha_raster.xkoord, 
            intersec_bdbed_wohnzone_industrie_landw_ha_raster.ykoord, 
            sum(intersec_bdbed_wohnzone_industrie_landw_ha_raster.flaeche) * (( SELECT c.emiss / 5297.08
                   FROM ( SELECT sum(uplus_20140526.emifrachtmsggf) AS emiss, 
                            uplus_20140526.emidsotyps AS schast
                           FROM ekat2015.uplus uplus_20140526
                          WHERE uplus_20140526.anldatid = 324 AND uplus_20140526.emidsotyps::text = 'Kohlenmonoxid'::text
                          GROUP BY uplus_20140526.emidsotyps) c)) AS emiss_co, 
            sum(intersec_bdbed_wohnzone_industrie_landw_ha_raster.flaeche) * (( SELECT c.emiss / 5297.08
                   FROM ( SELECT sum(uplus_20140526.emifrachtmsggf) AS emiss, 
                            uplus_20140526.emidsotyps AS schast
                           FROM ekat2015.uplus uplus_20140526
                          WHERE uplus_20140526.anldatid = 324 AND uplus_20140526.emidsotyps::text = 'Kohlendioxid'::text
                          GROUP BY uplus_20140526.emidsotyps) c)) AS emiss_co2, 
            sum(intersec_bdbed_wohnzone_industrie_landw_ha_raster.flaeche) * (( SELECT c.emiss / 5297.08
                   FROM ( SELECT sum(uplus_20140526.emifrachtmsggf) AS emiss, 
                            uplus_20140526.emidsotyps AS schast
                           FROM ekat2015.uplus uplus_20140526
                          WHERE uplus_20140526.anldatid = 324 AND uplus_20140526.emidsotyps::text = 'Stickoxide NOx, angegeben als NO2'::text
                          GROUP BY uplus_20140526.emidsotyps) c)) AS emiss_nox, 
            sum(intersec_bdbed_wohnzone_industrie_landw_ha_raster.flaeche) * (( SELECT c.emiss / 5297.08
                   FROM ( SELECT sum(uplus_20140526.emifrachtmsggf) AS emiss, 
                            uplus_20140526.emidsotyps AS schast
                           FROM ekat2015.uplus uplus_20140526
                          WHERE uplus_20140526.anldatid = 324 AND uplus_20140526.emidsotyps::text = 'Schwefeldioxid'::text
                          GROUP BY uplus_20140526.emidsotyps) c)) AS emiss_so2, 
            sum(intersec_bdbed_wohnzone_industrie_landw_ha_raster.flaeche) * (( SELECT c.emiss / 5297.08
                   FROM ( SELECT sum(uplus_20140526.emifrachtmsggf) AS emiss, 
                            uplus_20140526.emidsotyps AS schast
                           FROM ekat2015.uplus uplus_20140526
                          WHERE uplus_20140526.anldatid = 324 AND uplus_20140526.emidsotyps::text = 'Methan'::text
                          GROUP BY uplus_20140526.emidsotyps) c)) AS emiss_ch4, 
            sum(intersec_bdbed_wohnzone_industrie_landw_ha_raster.flaeche) * (( SELECT c.emiss / 5297.08
                   FROM ( SELECT sum(uplus_20140526.emifrachtmsggf) AS emiss, 
                            uplus_20140526.emidsotyps AS schast
                           FROM ekat2015.uplus uplus_20140526
                          WHERE uplus_20140526.anldatid = 324 AND uplus_20140526.emidsotyps::text = 'Feinstaub < 10 Mikrometer'::text
                          GROUP BY uplus_20140526.emidsotyps) c)) AS emiss_pm10, 
            sum(intersec_bdbed_wohnzone_industrie_landw_ha_raster.flaeche) * (( SELECT c.emiss / 5297.08
                   FROM ( SELECT sum(uplus_20140526.emifrachtmsggf) AS emiss, 
                            uplus_20140526.emidsotyps AS schast
                           FROM ekat2015.uplus uplus_20140526
                          WHERE uplus_20140526.anldatid = 324 AND uplus_20140526.emidsotyps::text = 'Ammoniak und Ammoniumverbindungen'::text
                          GROUP BY uplus_20140526.emidsotyps) c)) AS emiss_nh3, 
            sum(intersec_bdbed_wohnzone_industrie_landw_ha_raster.flaeche) * (( SELECT c.emiss / 5297.08
                   FROM ( SELECT sum(uplus_20140526.emifrachtmsggf) AS emiss, 
                            uplus_20140526.emidsotyps AS schast
                           FROM ekat2015.uplus uplus_20140526
                          WHERE uplus_20140526.anldatid = 324 AND uplus_20140526.emidsotyps::text = 'Lachgas'::text
                          GROUP BY uplus_20140526.emidsotyps) c)) AS emiss_n2o, 
            sum(intersec_bdbed_wohnzone_industrie_landw_ha_raster.flaeche) * (( SELECT c.emiss / 5297.08
                   FROM ( SELECT sum(uplus_20140526.emifrachtmsggf) AS emiss, 
                            uplus_20140526.emidsotyps AS schast
                           FROM ekat2015.uplus uplus_20140526
                          WHERE uplus_20140526.anldatid = 324 AND uplus_20140526.emidsotyps::text = 'Nichtmethan-Kohlenwasserstoffe, Lösemittel'::text AND (uplus_20140526.emidsoid <> ALL (ARRAY[1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 20, 27, 32, 40, 41, 50, 51, 57, 58, 62, 86, 87, 88, 89, 90, 91, 99, 100, 101, 182, 183, 190, 191, 192, 193, 194, 197, 200, 211, 223, 225, 280, 2073]))
                          GROUP BY uplus_20140526.emidsotyps) c)) AS emiss_nmvoc, 
            sum(intersec_bdbed_wohnzone_industrie_landw_ha_raster.flaeche) * (( SELECT c.emiss / 5297.08
                   FROM ( SELECT sum(uplus_20140526.emifrachtmsggf) AS emiss, 
                            uplus_20140526.emidsotyps AS schast
                           FROM ekat2015.uplus uplus_20140526
                          WHERE uplus_20140526.anldatid = 324 AND uplus_20140526.emidsotyps::text = 'Nichtmethan-Kohlenwasserstoffe, Lösemittel'::text AND (uplus_20140526.emidsoid <> ALL (ARRAY[1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 20, 27, 32, 40, 41, 50, 51, 57, 58, 62, 86, 87, 88, 89, 90, 91, 99, 100, 101, 182, 183, 190, 191, 192, 193, 194, 197, 200, 211, 223, 225, 280, 2073]))
                          GROUP BY uplus_20140526.emidsotyps) c)) AS emiss_xkw
           FROM ekat2015.intersec_bdbed_wohnzone_industrie_landw_ha_raster
          WHERE intersec_bdbed_wohnzone_industrie_landw_ha_raster.archive = 0 AND (intersec_bdbed_wohnzone_industrie_landw_ha_raster.art = ANY (ARRAY[0, 1, 2, 9, 11, 12]))
          GROUP BY intersec_bdbed_wohnzone_industrie_landw_ha_raster.xkoord, intersec_bdbed_wohnzone_industrie_landw_ha_raster.ykoord) b ON a.xkoord = b.xkoord::numeric AND a.ykoord = b.ykoord::numeric
  ORDER BY a.xkoord, a.ykoord;
