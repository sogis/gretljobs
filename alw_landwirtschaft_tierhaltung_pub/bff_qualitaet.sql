SELECT
    bff_qualitaet.t_id,
    bff_qualitaet.t_basket,
    bff_qualitaet.t_datasetname,
    bff_qualitaet.t_ili_tid,
    bff_qualitaet.geometrie,
    bff_qualitaet.bezugsjahr,
    bff_qualitaet.qualitaetstyp_code,
    bff_qualitaet.qualitaetsvariante_code,
    bff_qualitaet.kulturtyp_code,
    bff_qualitaet.datum_erstattest,
    bff_qualitaet.anzahl__baeume AS anzahl_baeume,
    bff_qualitaet.datum_kontrolle
FROM
    alw_landwirtschaft_tierhaltung_v1.bff_qualitaet_bff_qualitaet AS bff_qualitaet
WHERE
-- es wird immer nur ein Jahr publiziert
    bff_qualitaet.bezugsjahr = ${publikationsjahr_flaechenerhebung}
;