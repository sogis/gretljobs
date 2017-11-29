SELECT
    "Nichtschaden-ID" AS nichtschaden_id,
    "Kontaktperson_AfU" AS kontaktperson_afu,
    "Datum" AS datum,
    "Ort" AS ort,
    "Strasse_Nr" AS strasse_nr,
    "x-Koordinate" AS x_koordinate,
    "y-Koordinate" AS y_koordinate,
    "Kurzbeschrieb" AS kurzbeschrieb,
    "Bemerkungen" AS bemerkungen,
    wkb_geometry AS geometrie,
    oid AS t_id
FROM
    schadendienst.nichtschadenfaelle
;