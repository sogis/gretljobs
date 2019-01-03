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
    CASE
        WHEN code_entstehung.text = 'natürlich'
            THEN 'natuerlich'
        ELSE code_entstehung.text
    END AS entstehung,
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
        ELSE trim(code_oberflaechenform.text)
    END AS oberflaechenform,
    objektname,
    code_regionalgeologische_einheit.text AS regionalgeologische_einheit,
    trim(code_bedeutung.text) AS bedeutung,
    CASE
        WHEN code_zustand.text = 'nicht beeinträchtigt'
            THEN 'nicht_beeintraechtigt'
        WHEN code_zustand.text = 'gering beeinträchtigt'
            THEN 'gering_beeintraechtigt'
        WHEN code_zustand.text = 'stark beeinträchtigt'
            THEN 'stark_beeintraechtigt'
        WHEN code_zustand.text = 'zerstört'
            THEN 'zerstoert'
        ELSE code_zustand.text 
    END AS zustand,
    kurzbeschreibung AS beschreibung,
    CASE
        WHEN code_schuetzwuerdigkeit.text = 'schutzwürdig'
            THEN 'schutzwuerdig'
        WHEN code_schuetzwuerdigkeit.text = 'geschützt'
            THEN 'geschuetzt'
        ELSE trim(code_schuetzwuerdigkeit.text)
    END AS schutzwuerdigkeit,
    replace(trim(code_geowissenschaftlicher_wert.text), ' ', '_') AS geowissenschaftlicher_wert,
    code_anthropogene_gefaehrdung.text AS anthropogene_gefaehrdung,
    lokalname,
    kantonal_gesch AS kant_geschuetztes_objekt,
    ingeso_oid AS nummer,
    ingesonr_alt AS alte_inventar_nummer,
    quelle AS hinweis_literatur,
    ST_Multi(ST_SnapToGrid(wkb_geometry, 0.001)) AS geometrie
FROM
    ingeso.landsformen
    LEFT JOIN ingeso.code AS code_entstehung
        ON landsformen.objektart_allg = code_entstehung.code_id
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