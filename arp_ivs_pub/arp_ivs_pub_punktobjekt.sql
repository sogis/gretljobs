SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    ivssig
FROM 
    public.arp_ivsso_pnt
WHERE
    archive = 0
;