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
    bff_qualitaet.datum_kontrolle,
    CASE
        WHEN qualitaetstyp_code = 42000
            THEN 'BFF Qualität II'
        WHEN qualitaetstyp_code = 42010
            THEN 'Sömmerungsweide Qualität II'
    END AS qualitaetstyp,
    CASE
        WHEN qualitaetsvariante_code = 42030
            THEN 'Q normal'
        WHEN qualitaetsvariante_code = 42035
            THEN 'Q normal'
        WHEN qualitaetsvariante_code = 42040
            THEN 'Q Struktur'
        WHEN qualitaetsvariante_code = 42045
            THEN 'Q Flora'
        WHEN qualitaetsvariante_code = 42046
            THEN 'Q Struktur & Flora'
        WHEN qualitaetsvariante_code = 420469
            THEN 'Q aus Naturinventar'
    END AS qualitaetsvariante,
    CASE
        WHEN qualitaetstyp_code = 42000 AND kulturtyp_code = 42050
            THEN 'Unbestimmt'
        WHEN qualitaetstyp_code = 42000 AND kulturtyp_code = 42055
            THEN 'Wiese'
        WHEN qualitaetstyp_code = 42000 AND kulturtyp_code = 42060
            THEN 'Weide'
        WHEN qualitaetstyp_code = 42000 AND kulturtyp_code = 42061
            THEN 'Weide (BE)'
        WHEN qualitaetstyp_code = 42000 AND kulturtyp_code = 42065
            THEN 'Hecke'
        WHEN qualitaetstyp_code = 42000 AND kulturtyp_code = 42070
            THEN 'Bäume'
        WHEN qualitaetstyp_code = 42000 AND kulturtyp_code = 42075
            THEN 'Reben'
        WHEN qualitaetstyp_code = 42010 AND kulturtyp_code = 42050
            THEN 'Sömmerungsweide'
    END AS kulturtyp
FROM
    alw_landwirtschaft_tierhaltung_v1.bff_qualitaet_bff_qualitaet AS bff_qualitaet
WHERE
-- es wird immer nur ein Jahr publiziert
    bff_qualitaet.bezugsjahr = ${publikationsjahr_flaechenerhebung}
        AND
        (qualitaetstyp_code=42000
            OR  Qualitaetstyp_code=42010)

;