SELECT
    gid AS t_id,
    fm_id,
    round(CAST(area AS NUMERIC)/ 10000, 1) AS area,
    nr_id,
    bezeichung,
    wkb_geometry AS geometrie,
    ogc_fid
FROM
    public.arp_flachmoor
WHERE   
    archive = 0
;