SELECT
    CASE
        WHEN landschaftstyp = 468
            THEN 'Glaziallandschaft'
        WHEN landschaftstyp = 469
            THEN 'Moraene'
        WHEN landschaftstyp = 470
            THEN 'Schlucht_Klus_Halbklus'
        WHEN landschaftstyp = 471
            THEN 'Fluviallandschaft'
        WHEN landschaftstyp = 472
            THEN 'Karstlandschaft'
        WHEN landschaftstyp = 508
            THEN 'Gebirgslandschaft'
        WHEN landschaftstyp = 509
            THEN 'unbekannt'
        WHEN landschaftstyp = 520
            THEN 'Tal'
    END AS landschaftstyp,
    'bla' AS entstehung, -- welches Attribut?
    CASE
        WHEN objektart_spez = 138
            THEN 'Grundmoraene'
        WHEN objektart_spez = 150
            THEN 'Moraene'
        WHEN objektart_spez = 162
            THEN 'Seitenmoraene'
        WHEN objektart_spez = 417
            THEN 'Gletschermuehle'
        WHEN objektart_spez = 420
            THEN 'tektonische_Struktur'
        ELSE code_oberflaechenform.text 
    END AS oberflaechenform,
    objektname,
    code_regionalgeologische_einheit.text AS regionalgeologische_einheit,
    code_bedeutung.text AS bedeutung,
    code_zustand.text AS zustand,
    kurzbeschreibung AS beschreibung,
    code_schuetzwuerdigkeit.text AS schutzwuerdigkeit,
    code_geowissenschaftlicher_wert.text AS geowissenschaftlicher_wert,
    code_anthropogene_gefaehrdung.text AS anthropogene_gefaehrdung,
    lokalname,
    kantonal_gesch AS kant_geschuetztes_objekt,
    ingeso_oid AS nummer, --korrekt?
    ingesonr_alt AS alte_inventar_nummer,
    quelle AS hinweis_literatur, --korrekt?
    (ST_DUMP(wkb_geometry)).geom AS geometrie --gesplittet zu Polygon. Okay so?
FROM
    ingeso.landsformen
    LEFT JOIN ingeso.code AS code_oberflaechenform
        ON landsformen.objektart_spez = code_oberflaechenform.code_id
    LEFT JOIN ingeso.code AS code_regionalgeologische_einheit
        ON landsformen.regio_geol_einheit = code_regionalgeologische_einheit.code_id
    LEFT JOIN ingeso.code AS code_bedeutung
        ON landsformen.bedeutung = code_bedeutung.code_id
    LEFT JOIN ingeso.code AS code_zustand
        ON landsformen.zustand= code_zustand.code_id
    LEFT JOIN ingeso.code AS code_schuetzwuerdigkeit
        ON landsformen.schutzbedarf = code_schuetzwuerdigkeit.code_id
    LEFT JOIN ingeso.code AS code_geowissenschaftlicher_wert
        ON landsformen.geowiss_wert = code_geowissenschaftlicher_wert.code_id
    LEFT JOIN ingeso.code AS code_anthropogene_gefaehrdung
        ON landsformen.gefaehrdung = code_anthropogene_gefaehrdung.code_id
WHERE
    "archive" = 0
;