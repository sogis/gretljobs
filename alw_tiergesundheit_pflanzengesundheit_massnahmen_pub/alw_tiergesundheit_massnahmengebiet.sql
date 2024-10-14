SELECT
    geometrie,
    jahr,
    seuchenart,
    verwendungszweck,
    datum_installation,
    aktiv,
    datum_inaktiv,
    link_massnahmen,
    link_fachinfo,
    darstellung,
    apublic
FROM
    alw_tiergesundheit_pflanzengesundheit_massnahmen_v1.massnhmnrgsndheit_tiergesundheit_massnahmengebiet
WHERE
    aktiv = true
    AND 
    apublic = true
;