SELECT
    ogc_fid AS t_id,
    sturz,
    hangmure,
    grs,
    lawine,
    andere_kt,
    area,
    wkb_geometry AS geometrie
FROM
    awjf_work.silvaprotecteinteilig_sturz_kor
;