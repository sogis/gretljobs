SELECT
    wkb_geometry AS geometrie,
    status,
    oberflaeche,
    kategorie,
    wanderland,
    ogc_fid AS t_id
FROM
    public.arp_wweg
WHERE
    archive = 0
;