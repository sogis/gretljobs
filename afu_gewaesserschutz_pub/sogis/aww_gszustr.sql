SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    "name",
    im_kanton,
    typ,
    CASE
        WHEN typ = 'Zo'
            THEN 'Zo: Zuströmbereich für Oberflächengewässer'
        WHEN typ = 'Zu'
            THEN 'Zu: Zuströmbereich für Grundwasserfassung'
    END AS typ_text
FROM
    public.aww_gszustr
WHERE
    archive = 0 AND im_kanton = 0
;