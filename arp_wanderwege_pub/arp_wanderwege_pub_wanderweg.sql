SELECT
    wkb_geometry AS geometrie,
    status,
    CASE
        WHEN status = 11
            THEN 'bestehend'
        WHEN status = 12
            THEN 'geplant'
        WHEN status = 13
            THEN 'aufzuhebend'
    END AS status_txt,
    oberflaeche,
    CASE
        WHEN oberflaeche = 21
            THEN 'geeignet'
        WHEN oberflaeche = 22
            THEN 'ungeeignet'
        WHEN oberflaeche = 23
            THEN 'unbekannt'
    END AS oberflaeche_txt,
    kategorie,
    CASE
        WHEN kategorie = 31
            THEN 'Wanderweg'
        WHEN kategorie = 32
            THEN 'Bergwanderweg'
    END AS kategorie_txt,
    wanderland,
    ogc_fid AS t_id
FROM
    public.arp_wweg
WHERE
    archive = 0
;