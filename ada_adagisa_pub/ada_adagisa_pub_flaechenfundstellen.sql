SELECT
    ogc_fid AS t_id,
    gemeindenummer,
    laufnummer,
    fundstellennummer,
    gemeinde,
    flurname_adresse,
    art,
    geschuetzt,
    qualitaet_lokalisierung,
    kurzbeschreibung,
    grundbuchnummer,
    koord_x,
    koord_y,
    hoehe,
    landeskarte,
    geometrie,
    "source",
    "user" AS benutzer,
    status
FROM
    ada_adagis_a.flaechenfundstellen
WHERE
    archive = false
;