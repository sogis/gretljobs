SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    haltest_id,
    haltestell,
    nr_tu,
    anzahl_hs,
    didok,
    verkehrsmittel
FROM
    public.avt_oev_haltestellen
WHERE
    "archive" = 0;