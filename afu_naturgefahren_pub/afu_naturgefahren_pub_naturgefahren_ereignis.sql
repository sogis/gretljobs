SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    datum,
    prozess_typ,
    storme_nr,
    jahr,
    gem_bfs,
    bezirk_nr,
    kanton_nr
FROM
    public.aww_natgef_ereignis
WHERE
    archive = 0
