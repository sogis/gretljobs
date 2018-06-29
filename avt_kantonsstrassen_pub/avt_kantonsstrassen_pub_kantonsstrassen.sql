SELECT
    geometrie geometry,
    name,
    plz_ortschaft,
    klasse,
    kategorie,
    "KSNr",
    "Strassentyp",
    "Strasseneigner",
    "OeV-Nutzung",
    "ObjectID",
    "AGI_Strid",
    "AV_Seq",
    "AGr",
    istoffiziellebezeichnung
FROM
    strassennetz.klasse_kategorie
WHERE
    "Strasseneigner" = 'Kanton'
;