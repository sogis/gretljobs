SELECT
    flaecheid AS t_id,
    bezeichnung,
    wkb_geometry AS geometrie,
    statustyp,
    aktiv,
    erfassungsdatum,
    datenerfasser,
    belastungstyp,
    begruendung_inaktiv,
    inaktiv_date
FROM
    vsb.flaeche
WHERE
    archive = 0
;