SELECT
    ogc_fid AS t_id,
    xkoord,
    ykoord,
    wkb_geometry AS geometrie,
    gem_bfs,
    emiss_co,
    emiss_nox,
    emiss_so2,
    emiss_nmvoc,
    emiss_pm10,
    emiss_nh3,
    emiss_xkw,
    emiss_co2,
    emiss_ch4,
    emiss_n2o
FROM
    ekat2010.verkehr_mapserver
;
