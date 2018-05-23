SELECT
    verkehrsmodell2013_all.so_id AS t_id,
    verkehrsmodell2013_all.nummer,
    verkehrsmodell2013_all.sostrid,
    verkehrsmodell2013_all.fromnodeno,
    verkehrsmodell2013_all.tonodeno,
    verkehrsmodell2013_all.asp2010,
    verkehrsmodell2013_all.asp2010_pkw,
    verkehrsmodell2013_all.asp2010_li,
    verkehrsmodell2013_all.asp2010_lw,
    verkehrsmodell2013_all.asp2010_lz,
    verkehrsmodell2013_all.asp2030,
    verkehrsmodell2013_all.asp2030_pkw,
    verkehrsmodell2013_all.asp2030_li,
    verkehrsmodell2013_all.asp2030_lw,
    verkehrsmodell2013_all.asp2030_lz,
    verkehrsmodell2013_all.dtv2010,
    verkehrsmodell2013_all.dtv2010_pkw,
    verkehrsmodell2013_all.dtv2010_li,
    verkehrsmodell2013_all.dtv2010_lw,
    verkehrsmodell2013_all.dtv2010_lz,
    CASE
        WHEN verkehrsmodell2013_all.dtv2010 BETWEEN 0 AND 1999
            THEN '< 2000'
        WHEN verkehrsmodell2013_all.dtv2010 BETWEEN 2000 AND 3999
            THEN '2000 - 4000'
        WHEN verkehrsmodell2013_all.dtv2010 BETWEEN 4000 AND 5999
            THEN '4000 - 6000'
        WHEN verkehrsmodell2013_all.dtv2010 BETWEEN 6000 AND 9999
            THEN '6000 - 10''000'
        WHEN verkehrsmodell2013_all.dtv2010 BETWEEN 10000 AND 19999
            THEN '10''000 - 20''000'
        WHEN verkehrsmodell2013_all.dtv2010 BETWEEN 20000 AND 29999
            THEN '20''000 - 30''000'
        WHEN verkehrsmodell2013_all.dtv2010 BETWEEN 30000 AND 49999
            THEN '30''000 - 50''000'
        WHEN verkehrsmodell2013_all.dtv2010 >= 50000
            THEN '> 50''000'
        WHEN verkehrsmodell2013_all.dtv2010 IS NULL
            THEN 'keine Angaben'
    END AS dtv2010_text,
    verkehrsmodell2013_all.dtv2020,
    verkehrsmodell2013_all.dtv2020_pkw,
    verkehrsmodell2013_all.dtv2020_li,
    verkehrsmodell2013_all.dtv2020_lw,
    verkehrsmodell2013_all.dtv2020_lz,
        CASE
        WHEN verkehrsmodell2013_all.dtv2020 BETWEEN 0 AND 1999
            THEN '< 2000'
        WHEN verkehrsmodell2013_all.dtv2020 BETWEEN 2000 AND 3999
            THEN '2000 - 4000'
        WHEN verkehrsmodell2013_all.dtv2020 BETWEEN 4000 AND 5999
            THEN '4000 - 6000'
        WHEN verkehrsmodell2013_all.dtv2020 BETWEEN 6000 AND 9999
            THEN '6000 - 10''000'
        WHEN verkehrsmodell2013_all.dtv2020 BETWEEN 10000 AND 19999
            THEN '10''000 - 20''000'
        WHEN verkehrsmodell2013_all.dtv2020 BETWEEN 20000 AND 29999
            THEN '20''000 - 30''000'
        WHEN verkehrsmodell2013_all.dtv2020 BETWEEN 30000 AND 49999
            THEN '30''000 - 50''000'
        WHEN verkehrsmodell2013_all.dtv2020 >= 50000
            THEN '> 50''000'
        WHEN verkehrsmodell2013_all.dtv2020 IS NULL
            THEN 'keine Angaben'
    END AS dtv2020_text,
    verkehrsmodell2013_all.dtv2030,
    verkehrsmodell2013_all.dtv2030_pkw,
    verkehrsmodell2013_all.dtv2030_li,
    verkehrsmodell2013_all.dtv2030_lw,
    verkehrsmodell2013_all.dtv2030_lz,
    verkehrsmodell2013_all.dwv2010,
    verkehrsmodell2013_all.dwv2010_pkw,
    verkehrsmodell2013_all.dwv2010_li,
    verkehrsmodell2013_all.dwv2010_lw,
    verkehrsmodell2013_all.dwv2010_lz,
    verkehrsmodell2013_all.dwv2030,
    verkehrsmodell2013_all.dwv2030_pkw,
    verkehrsmodell2013_all.dwv2030_li,
    verkehrsmodell2013_all.dwv2030_lw,
    verkehrsmodell2013_all.dwv2030_lz,
    verkehrsmodell2013_all.msp2010,
    verkehrsmodell2013_all.msp2010_pkw,
    verkehrsmodell2013_all.msp2010_li,
    verkehrsmodell2013_all.msp2010_lw,
    verkehrsmodell2013_all.msp2010_lz,
    verkehrsmodell2013_all.msp2030,
    verkehrsmodell2013_all.msp2030_pkw,
    verkehrsmodell2013_all.msp2030_li,
    verkehrsmodell2013_all.msp2030_lw,
    verkehrsmodell2013_all.msp2030_lz,
    verkehrsmodell2013_all.nodeno,
    verkehrsmodell2013_all.neigung_be,
    verkehrsmodell2013_all.laenge,
    verkehrsmodell2013_all.wkb_geometry AS geometrie,
    verkehrsmodell2013_all.ogc_fid,
    verkehrsmodell2013_all.klasse,
    geschw_kap_sum_v2.geschw2010,
    geschw_kap_sum_v2.cap2010,
    geschw_kap_sum_v2.geschw2020,
    geschw_kap_sum_v2.cap2020,
    geschw_kap_sum_v2.geschw2030,
    geschw_kap_sum_v2.cap2030
FROM
    verkehrsmodell2013.verkehrsmodell2013_all
    LEFT JOIN verkehrsmodell.geschw_kap_sum_v2
        ON 
            geschw_kap_sum_v2.nummer = verkehrsmodell2013_all.nummer
            AND
            geschw_kap_sum_v2.sostrid = verkehrsmodell2013_all.sostrid
            AND
            geschw_kap_sum_v2.so_id = verkehrsmodell2013_all.so_id
;