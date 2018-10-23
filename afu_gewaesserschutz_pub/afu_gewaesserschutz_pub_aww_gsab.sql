SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    erf_datum,
    zone,
    CASE
        WHEN zone = 'U'
            THEN 'Au: Schutzbereich Grundwasser'
        WHEN zone = 'B'
            THEN 'Üb: übrige Bereiche Grundwasser'
        WHEN zone = 'O'
            THEN 'Ao: Schutzbereich Oberflächengewässer'
    END AS zone_text,
    erfasser,
    symbol
FROM
    aww_gsab
WHERE
    archive = 0
;
