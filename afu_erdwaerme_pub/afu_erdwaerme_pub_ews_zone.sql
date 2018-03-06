SELECT
    id_nr,
    sto_code,
    wkb_geometry AS geometrie,
    ogc_fid AS t_id 
FROM
    public.aww_ews_flaechen
WHERE
    archive = 0
;