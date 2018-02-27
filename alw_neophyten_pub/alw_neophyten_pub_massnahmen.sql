SELECT
    ogc_fid AS t_id,
    einbaudatum,
    ausmass,
    ueberdeckung,
    material,
    beschreibung,
    bauherr_eigner,
    grundeigentuemer,
    ansprechperson,
    dauer,
    termin_entnahme,
    allgemein,
    wkb_geometry AS geometrie,
    erfasser
FROM
    neophyten.massnahmen_t
WHERE
    archive = 0
;