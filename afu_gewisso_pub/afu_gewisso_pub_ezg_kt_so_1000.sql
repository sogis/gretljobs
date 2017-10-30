SELECT 
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    objectid,
    ezgnr,
    teilezgnr,
    gwlnr,
    measure,
    gewissnr,
    ch,
    see,
    h1,
    h2,
    kanal,
    flussgb,
    "release",
    mutation,
    hierarchie,
    interns,
    poly_id,
    tezgnr40,
    tezgnr150,
    tezgnr1000,
    shape_leng,
    shape_area,
    area1000,
    area_ha,
    color
FROM
    gewisso.ezg_kt_so_1000
WHERE
    "archive" = 0;