SELECT
    g.identifikator,
    g.bauprojekt ->> 'Beschreibung'             AS titel,
    g.bfsnr,
    g.verfahrensart,
    g.astatus                                  AS status_geschaeft,
    g.entscheid_leitbehoerde ->> 'Entscheid'     AS entscheid,
    (g.entscheid_leitbehoerde ->> 'Datum')::date AS entscheid_datum,
    g.zustaendige_personen ->> 'Fachstelle'     AS zustaendige_fachstelle,
    g.zustaendige_personen ->> 'Abteilung'      AS zustaendige_abteilung,
    g.ausserhalb_bauzone,
    g.ebau_link,
    g.geometrie_punkt                          AS geometrie
FROM dsbjd_ebauso_geschaefte_v1.geschaefte_geschaeft AS g
WHERE g.zirkulation @> '[{"Fachstelle":"AFU"}]'::jsonb
  AND g.geometrie_punkt IS NOT NULL;