SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    sturz,
    hangmure,
    grs,
    lawine,
    andere_kt,
    area
FROM
    awjf_work.silvaprotecteinteilig_grs_kor
;