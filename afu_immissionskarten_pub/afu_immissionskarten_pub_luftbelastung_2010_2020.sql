SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    x,
    y,
    ino2_2010,
    ino2_2020,
    ipm10_2010,
    ipm10_2020,
    ipm25_2010,
    ipm25_2020
FROM
    immissionskarten_luft.luftbelastung_2010_2020
;