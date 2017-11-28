SELECT
    ogc_fid AS t_id,
    xkoord,
    ykoord,
    wkb_geometry AS geometrie,
    gem_bfs,
    emiss_so2,
    emiss_nox,
    emiss_co,
    emiss_ch4,
    emiss_pm10,
    emiss_nh3,
    emiss_nmvoc,
    emiss_co2,
    emiss_n2o,
    emiss_xkw
FROM
    ekat.temp_alle
;