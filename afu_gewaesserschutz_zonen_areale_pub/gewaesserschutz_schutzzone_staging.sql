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
                'SO_AFU_Gewaesserschutz_Publikation_20240501.Gewaesserschutz.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument
),
--
json_dokument_agg AS (
    SELECT
        gwszone_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_schutzzone.gwszone AS gwszone_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN afu_gewaesserschutz_zonen_areale_v1.gwszonen_rechtsvorschriftgwszone AS dokument_schutzzone
            ON dokument_schutzzone.rechtsvorschrift = json_documents.t_id
        GROUP BY
        dokument_schutzzone.gwszone
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
    CASE
        WHEN status.rechtsstatus ILIKE 'inKraft' THEN status.rechtsstatus
        WHEN status.rechtsstatus ILIKE 'provisorisch' AND status.kantonalerstatus ILIKE 'AenderungOhneVorwirkung' THEN 'AenderungOhneVorwirkung'
        WHEN status.rechtsstatus ILIKE 'provisorisch' AND status.kantonalerstatus ILIKE 'AenderungMitVorwirkung' THEN 'AenderungMitVorwirkung'
        ELSE 'provisorisch'
    END AS rechtsstatus,
    g.bemerkungen AS bemerkung
FROM
    afu_gewaesserschutz_zonen_areale_v1.gwszonen_gwszone g
LEFT JOIN
    afu_gewaesserschutz_zonen_areale_v1.gwszonen_status status
    ON status.t_id = g.astatus
LEFT JOIN json_dokument_agg
    ON g.t_id= json_dokument_agg.gwszone_t_id