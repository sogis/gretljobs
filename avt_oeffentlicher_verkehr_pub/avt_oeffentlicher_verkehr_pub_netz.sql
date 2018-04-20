SELECT
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    CASE
        WHEN typ = 1
            THEN 'Bus'
        WHEN typ = 2
            THEN 'SBB'
        WHEN typ = 3
            THEN 'Regionalbahn'
    END AS  typ,
    CASE
        WHEN herkunft = 1
            THEN 'kopiert (Strassenetz, Achsen der Kantonsstrassen)'
        WHEN herkunft = 2
            THEN 'Manuell digitalisiert (z.B. von Orthofoto)'
    END AS  herkunft
FROM
    public.avt_oev_netz
WHERE
    "archive" = 0
;