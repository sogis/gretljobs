SELECT
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
    wkb_geometry AS geometrie
FROM
    ingeso.hoehlen
    LEFT JOIN ingeso.code AS code_regionalgeologische_einheit
        ON hoehlen.regio_geol_einheit = code_regionalgeologische_einheit.code_id
    LEFT JOIN ingeso.code AS code_bedeutung
        ON hoehlen.bedeutung = code_bedeutung.code_id
    LEFT JOIN ingeso.code AS code_zustand
        ON hoehlen.zustand= code_zustand.code_id
    LEFT JOIN ingeso.code AS code_schuetzwuerdigkeit
        ON hoehlen.schutzbedarf = code_schuetzwuerdigkeit.code_id
    LEFT JOIN ingeso.code AS code_geowissenschaftlicher_wert
        ON hoehlen.geowiss_wert = code_geowissenschaftlicher_wert.code_id
    LEFT JOIN ingeso.code AS code_anthropogene_gefaehrdung
        ON hoehlen.gefaehrdung = code_anthropogene_gefaehrdung.code_id
WHERE
    "archive" = 0
    AND
    objektart_spez = 425
;