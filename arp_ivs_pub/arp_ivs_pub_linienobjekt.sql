SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    ivssig,
    ivsid,
    ivsnr,
    ivsname,
    ivstyp,
    ivskanton,
    ivssort,
    concat('<a href="../docs/ch.so.arp.ivs/', ivssort,'.pdf" target="_blank">Objektblatt</a>')
FROM
    public.arp_ivsso_line
WHERE
    archive = 0
;