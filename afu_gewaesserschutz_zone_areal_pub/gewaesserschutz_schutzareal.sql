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
                titel AS "Titel",
                offiziellertitel AS "OffiziellerTitel",
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "OffizielleNr",
                kanton AS "Kanton",
                gemeinde AS "Gemeinde",
                publiziertab AS "publiziertAb",
                rechtsstatus AS "Rechtsstatus",
                textimweb AS "TextimWeb",
                art AS "Art",
                'SO_AfU_Gewaesserschutz_Publikation_20220817.Gewaesserschutz.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        afu_gewaesserschutz.gwszonen_dokument
),
--
json_dokument_agg AS (
    SELECT
        gwsareal_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_schutzzone.gwsareal AS gwsareal_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN afu_gewaesserschutz.gwszonen_rechtsvorschriftgwsareal AS dokument_schutzzone
            ON dokument_schutzzone.rechtsvorschrift = json_documents.t_id
        GROUP BY
        dokument_schutzzone.gwsareal
    ) AS a
)

SELECT 
    g.typ AS typ,
    CASE istaltrechtlich
        WHEN TRUE THEN FALSE
        ELSE TRUE
        END AS gesetzeskonform,
    status.rechtskraftdatum AS rechtskraftdatum,
    json_dokument_agg.dokumente::json AS dokumente,
    g.geometrie AS apolygon,
    CASE status.rechtsstatus
        WHEN 'inKraft' THEN status.rechtsstatus
        ELSE 'AenderungOhneVorwirkung'
        END AS rechtsstatus,
    g.bemerkungen AS bemerkung
FROM
    afu_gewaesserschutz.gwszonen_gwsareal g
LEFT JOIN
    afu_gewaesserschutz.gwszonen_status status
    ON status.t_id = g.astatus
LEFT JOIN json_dokument_agg
    ON g.t_id= json_dokument_agg.gwsareal_t_id