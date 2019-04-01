SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    objectid,
    "name",
    akten_nr_t,
    akten_nr,
    standort_n,
    gb_kat,
    CASE
        WHEN gb_kat = 1
            THEN 'Ausgangslage'
        WHEN gb_kat = 2
            THEN 'Festsetzung'
        WHEN gb_kat = 3
            THEN 'Erweiterungs- / Ersatzstandort'
        WHEN gb_kat = 5
            THEN 'Abbau abgeschlossen / rekultiviert'
        WHEN gb_kat = 6
            THEN 'keine Angabe (nicht im Grundlagenbericht)'
    END AS gb_kat_text,
    rip_kat,
    CASE
        WHEN rip_kat = 0
            THEN 'kein Richtplaneintrag'
        WHEN rip_kat = 1
            THEN 'Ausgangslage'
        WHEN rip_kat = 2
            THEN 'Festsetzung'
        WHEN rip_kat = 3
            THEN 'Zwischenergebnis'
        WHEN rip_kat = 4
            THEN 'Vororientierung'
    END AS rip_kat_text,
    mat,
    CASE
        WHEN mat = 1
            THEN 'Kies'
        WHEN mat = 2
            THEN 'Kalk'
        WHEN mat = 3
            THEN 'Ton'
        WHEN mat = 4
            THEN 'Kleinabbau (Mergel, Kalk, Ton, Kies)'
    END AS mat_text,
    zeitstand,
    CASE
        WHEN zeitstand = '0'
            THEN 'Kleinabbaustelle (ohne Konzept +'
        WHEN zeitstand = '1'
            THEN 'Richtplaneintrag)'
        WHEN zeitstand = '2'
            THEN 'Kieskonzept 1990'
        WHEN zeitstand = '3'
            THEN 'Steinbruchkonzept 1994'
        WHEN zeitstand = '4'
            THEN 'Richtplan 2000'
        WHEN zeitstand = '5'
            THEN 'Abbaukonzept 2009'
        WHEN zeitstand = '6'
            THEN 'Richtplan aktuell'
        WHEN zeitstand = '7'
            THEN 'Teilregionales Abbaukonzept Gäu Nutzungsplanung'
    END AS zeitstand_text,
    nach_dat,
    bschl,
    CASE
        WHEN bschl = '0'
            THEN 'keine'
        WHEN bschl = '1'
            THEN 'Regierungsratbeschluss'
        WHEN bschl = '2'
            THEN 'Richtplanbeschluss'
        WHEN bschl = '3'
            THEN 'Verfügung'
    END AS bschl_text,
    bschl_dat,
    bschl_guel,
    bem,
    shape_area
FROM
    abbaustellen.abbaustellen
WHERE
    archive = 0
    AND
    planungsstand IS NULL
;