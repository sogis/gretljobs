SELECT
    p.projektname,
    p.vertragsbeginn,
    p.anerkennung,
    p.amo_nr,
    p.los_nr,
    p.archiv_nr,
    p.bemerkung,
    p.taetigkeit,

    CASE
        WHEN f.geometer IS NOT NULL
             AND trim(f.geometer) <> ''
        THEN concat(f.firma, ' (', f.geometer, ')')
        ELSE f.firma
    END AS firma,

    g.geometriename,
    g.bfs_nr,
    g.geometrie,

    d.dokumentenname AS dokumentname,
    d.nummer         AS dokumentnummer,
    d.url

    FROM
        agi_av_projektinformationen_v1.projektinformtnen_projekt p

        LEFT JOIN
            agi_av_projektinformationen_v1.projektinformtnen_projekt_firma pf
            ON pf.projekt_r = p.t_id

        LEFT JOIN
            agi_av_projektinformationen_v1.projektinformtnen_firma f
            ON f.t_id = pf.firma_r

        LEFT JOIN
            agi_av_projektinformationen_v1.projektinformtnen_projekt_geometrie pg
            ON pg.projekt_r = p.t_id

        LEFT JOIN
            agi_av_projektinformationen_v1.projektinformtnen_geometrie g
            ON g.t_id = pg.geometrie_r

        LEFT JOIN
            agi_av_projektinformationen_v1.projektinformtnen_projekt_dokument pd
            ON pd.projekt_r = p.t_id

        LEFT JOIN
            agi_av_projektinformationen_v1.projektinformtnen_dokument d
            ON d.t_id = pd.dokument_r
    ;