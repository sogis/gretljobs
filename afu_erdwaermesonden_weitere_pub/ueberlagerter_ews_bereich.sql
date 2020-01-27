SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    area,
    perimeter,
    lockg_,
    lockg_id,
    art
FROM
    public.aww_wpkart_lockg
WHERE 
    archive = 0
;