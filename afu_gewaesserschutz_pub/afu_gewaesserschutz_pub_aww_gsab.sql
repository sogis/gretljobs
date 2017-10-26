SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    erf_datum,
    zone,
    erfasser,
    symbol
FROM
    aww_gsab
WHERE
    archive = 0;
