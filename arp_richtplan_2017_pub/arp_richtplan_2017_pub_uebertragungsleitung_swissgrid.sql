SELECT
    trabsnr,
    trassename,
    spannung,
    geometrie,
    ogc_fid AS t_id
FROM
    arp_richtplan_2017.uebertragungsleitung_swissgrid
;