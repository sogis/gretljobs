SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    ivssig,
    ivsid,
    ivsnr,
    ivsname,
    ivstyp,
    ivskanton,
    ivssort
FROM
    public.arp_ivsso_line
WHERE
    archive = 0
;