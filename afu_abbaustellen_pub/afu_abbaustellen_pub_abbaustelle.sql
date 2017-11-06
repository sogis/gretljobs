SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    objectid,
    "name",
    akten_nr_t,
    akten_nr,
    standort_n,
    gb_kat,
    rip_kat,
    mat,
    zeitstand,
    nach_dat,
    bschl,
    bschl_dat,
    bschl_guel,
    bem,
    shape_area
FROM
    abbaustellen.abbaustellen
WHERE
    "archive" = 0