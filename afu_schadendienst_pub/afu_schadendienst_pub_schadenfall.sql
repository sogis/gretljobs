SELECT
    "schaden-nr" AS schaden_nr,
    jahr,
    "Sachbearbeiter" AS sachbearbeiter,
    datum,
    ort,
    "strasse/nr" AS strasse_nr,
    gewaesserschutzzone,
    code,
    ursache,
    "name",
    adresse,
    ort2,
    telefon,
    x,
    y,
    art,
    menge,
    hergang,
    massnahmen,
    bemerkungen,
    schaden_id,
    wkb_geometry AS geometrie,
    "oid",
    ogc_fid AS t_id 
FROM
    schadendienst.schadenfaelle_n
WHERE
    archive = 0
;