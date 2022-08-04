with json_documents AS (
    SELECT
  (
    row_to_json
    ((
        SELECT
            docs
        FROM
        (
            SELECT
                typ AS "Titel",
                offiziellertitel AS "Offizieller_Titel",
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "Offizielle_Nr",
                kanton AS "Kanton",
                gemeinde AS "Gemeinde",
                publiziert_ab AS "publiziert_ab",
                rechtsstatus AS "Rechtsstatus",
                text_im_web AS "Text_im_Web",
                bemerkungen AS "Bemerkungen",
                datum_archivierung AS "Datum_Archivierung",
                erfasser AS "Erfasser",
                datum_erfassung AS "Datum_Erfassung",
                'SO_AWJF_Statische_Waldgrenzen_Publikation_20191119.Waldgrenze.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        awjf_statische_waldgrenze.dokumente_dokument
),

typ_waldgrenze_json_dokument_agg AS (
    SELECT
        festlegung_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_waldgrenze.festlegung AS festlegung_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN awjf_statische_waldgrenze.geobasisdaten_typ_dokument AS dokument_waldgrenze
            ON dokument_waldgrenze.dokumente = json_documents.t_id
        GROUP BY
        dokument_waldgrenze.festlegung
    ) AS a
)

SELECT 
    typ.bezeichnung AS typ_bezeichnung,
    typ.abkuerzung AS typ_abkuerzung,
    typ.verbindlichkeit AS typ_verbindlichkeit,
    typ.bemerkungen AS typ_bemerkungen,
    typ.art AS typ_art,
    waldgrenze.geometrie AS geometrie,
    waldgrenze.nummer AS nummer,
    waldgrenze.rechtsstatus AS rechtsstatus,
    waldgrenze.publiziert_ab AS publiziert_ab,
    waldgrenze.bemerkungen AS bemerkungen,
    waldgrenze.erfasser AS erfasser,
    waldgrenze.datum_erfassung AS datum_erfassung,
    typ_waldgrenze_json_dokument_agg.dokumente::json AS dokumente,
    waldgrenze.genehmigt_am AS genehmigt_am,
    waldgrenze.datum_archivierung AS datum_archivierung
FROM
    awjf_statische_waldgrenze.geobasisdaten_waldgrenze_linie waldgrenze
LEFT JOIN
    awjf_statische_waldgrenze.geobasisdaten_typ typ
    ON waldgrenze.waldgrenze_typ = typ.t_id
LEFT JOIN typ_waldgrenze_json_dokument_agg
    ON typ.t_id= typ_waldgrenze_json_dokument_agg.festlegung_t_id