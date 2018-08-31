SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    gem_bfs,
    gmde_name,
    plz,
    kkw,
    zone_1,
    s1,
    s2,
    s3,
    s4,
    s5,
    s6
FROM
    notfallplanung_kkw.zonen_notfall
WHERE
    archive = 0
;