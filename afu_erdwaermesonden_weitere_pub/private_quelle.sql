SELECT
    ogc_fid AS t_id,
    area,
    perimeter,
    erdabp_,
    erdabp_id,
    wkb_geometry AS geometrie
FROM
    public.aww_wpkart_priv
WHERE  
    archive = 0
;
