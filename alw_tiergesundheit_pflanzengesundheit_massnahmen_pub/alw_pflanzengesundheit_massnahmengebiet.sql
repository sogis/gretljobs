SELECT
    geometrie,
    jahr,
    schadorganismus,
    verwendungszweck,
    datum_installation,
    aktiv,
    datum_inaktiv,
    link_massnahmen,
    link_fachinfo,
    darstellung,
    apublic
FROM
    alw_tiergesundheit_pflanzengesundheit_massnahmen_v1.massnhmnngsndheit_pflanzengesundheit_schadorganismen
WHERE
    aktiv = true
    AND 
    apublic = true
;
