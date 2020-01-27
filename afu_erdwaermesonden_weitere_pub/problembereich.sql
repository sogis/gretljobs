SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    area,
    perimeter,
    probl_,
    probl_id,
    art
FROM
    public.aww_wpkart_probl
WHERE
    archive = 0
;