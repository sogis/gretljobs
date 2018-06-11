SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    datum,
    prozess_typ,
    CASE
        WHEN prozess_typ = 'W'
            THEN 'Wasser'
        WHEN prozess_typ = 'R'
            THEN 'Rutschung'
        WHEN prozess_typ = 'S'
            THEN 'Sturz'
        WHEN prozess_typ = 'L'
            THEN 'Lawine'   
    END AS  prozess_typ_text,
    storme_nr,
    jahr,
    gem_bfs,
    bezirk_nr,
    kanton_nr
FROM
    public.aww_natgef_ereignis
WHERE
    archive = 0
