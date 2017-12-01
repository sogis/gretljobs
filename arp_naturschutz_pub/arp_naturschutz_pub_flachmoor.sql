SELECT
    gid AS t_id,
    fm_id,
    area,
    nr_id,
    bezeichung,
    wkb_geometry AS geometrie,
    ogc_fid
FROM
    public.arp_flachmoor
WHERE   
    archive = 0
;