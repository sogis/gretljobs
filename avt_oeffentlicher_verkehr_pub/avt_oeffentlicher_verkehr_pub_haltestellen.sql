SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    haltest_id,
    haltestell,
    CASE
        WHEN nr_tu = 1
            THEN 'BLT (Bus + Tram)'
        WHEN nr_tu = 2
            THEN 'AAR (Bus)'
        WHEN nr_tu = 3
            THEN 'Post BE-FR-SO, Thal (Bus)'
        WHEN nr_tu = 4
            THEN 'BLS (Bahn)'
        WHEN nr_tu = 5
            THEN 'RBS (Bahn)'
        WHEN nr_tu = 6
            THEN 'SBB (Bahn)'
         WHEN nr_tu = 7
            THEN 'OeBB (Bahn)'
        WHEN nr_tu = 9
            THEN 'Asm (Bahn)'
         WHEN nr_tu = 10
            THEN 'Post NWCH (Bus)'
        WHEN nr_tu = 11
            THEN 'BGU (Bus)'
        WHEN nr_tu = 12
            THEN 'BSU (Bus)'
        WHEN nr_tu = 13
            THEN 'BOGG (Bus)'
    END AS nr_tu,
    anzahl_hs,
    didok,
    CASE
        WHEN verkehrsmittel = 1
            THEN 'Bus bzw. Bushaltestelle'
        WHEN verkehrsmittel = 2
            THEN 'Zug bzw. Bahnhof'
        WHEN verkehrsmittel = 3
            THEN 'Regionalbahn bzw. Regionalbahnhof'
    END AS verkehrsmittel
FROM
    public.avt_oev_haltestellen
WHERE
    archive = 0
;