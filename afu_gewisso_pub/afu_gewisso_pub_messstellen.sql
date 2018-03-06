SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    "name",
    typ,
    geraete_id,
    x,
    y,
    muebm,
    strom,
    messdaten,
    festnetz,
    mobile,
    ftp,
    geraetetyp,
    inbetriebnahme,
    logger,
    inbetriebnahme1,
    messinterval,
    datenabfrage
FROM
    gewisso.messstellen
WHERE
    archive = 0
;