SELECT
    geometrie,
    jahr,
    seuchenart,
    verwendungszweck,
    datum_installation,
    aktiv,
    datum_inaktiv
FROM
    alw_tiergesundheit_massnahmen.massnhmnrgsndheit_tiergesundheit_massnahmengebiet
WHERE
    aktiv = true
;
