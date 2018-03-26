SELECT
    gid AS t_id,
    baseid,
    cko_owner,
    ck,
    pos_code,
    no_segm,
    visibilite,
    laenge,
    laen_ber,
    id,
    tunnel,
    kb,
    the_geom AS geometrie
FROM
    sorkas.natstr
;