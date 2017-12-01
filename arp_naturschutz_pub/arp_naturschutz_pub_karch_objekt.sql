SELECT
    ogc_fid AS t_id,
    karch_id,
    nr,
    obname,
    x_koord,
    y_koord,
    ianb,
    wkb_geometry AS geometrie
FROM
    naturschutz.karch_objekte
;
