WITH RECURSIVE x(ursprung, hinweis, parents, last_ursprung, depth) AS (
    SELECT
        ursprung,
        hinweis,
        ARRAY[ursprung] AS parents,
        ursprung AS last_ursprung,
        0 AS "depth"
    FROM
        arp_npl.rechtsvorschrften_hinweisweiteredokumente

    UNION ALL

    SELECT
        x.ursprung,
        x.hinweis,
        parents || rechtsvorschrften_hinweisweiteredokumente_1.hinweis,
        rechtsvorschrften_hinweisweiteredokumente_1.hinweis AS last_ursprung,
        x."depth" + 1
    FROM
        x
        INNER JOIN arp_npl.rechtsvorschrften_hinweisweiteredokumente  AS rechtsvorschrften_hinweisweiteredokumente_1
            ON last_ursprung = rechtsvorschrften_hinweisweiteredokumente_1.ursprung
    WHERE 
        rechtsvorschrften_hinweisweiteredokumente_1.hinweis IS NOT NULL
), 
doc_doc_references_all AS (
    SELECT
        ursprung,
        hinweis,
        parents,
        depth
    FROM
        x
    WHERE
        depth = (
            SELECT
                max(subquery."depth")
            FROM
                x AS subquery
            WHERE
                subquery.ursprung = x.ursprung
            )
),
doc_doc_references AS (
    SELECT
        ursprung,
        a_parents AS dok_dok_referenzen
    FROM
        (
            SELECT DISTINCT ON (a_parents)
                a.ursprung,
                a.parents AS a_parents,
                b.parents AS b_parents
            FROM
                doc_doc_references_all AS a
                LEFT JOIN doc_doc_references_all AS b
                    ON a.parents <@ b.parents AND a.parents != b.parents
        ) AS subquery
    WHERE
        b_parents IS NULL
),
json_documents_all AS (
    SELECT
        t_id,
        row_to_json(dokumente)::text AS json_dokument
    FROM
        (
            SELECT
                t_id,
                t_ili_tid,
                CASE
                    WHEN offiziellertitel IS NULL
                        THEN titel
                    ELSE offiziellertitel
                END AS titel,
                publiziertab,
                ('https://geo.so.ch/docs/ch.so.arp.zonenplaene/Zonenplaene_pdf/'||"textimweb")::text AS dateipfad,
                bemerkungen AS bemerkung
            FROM
                arp_npl.rechtsvorschrften_dokument
        ) AS dokumente
),
json_documents_doc_doc_reference AS (
    SELECT
        t_id,
        json_dokument
    FROM
        (
            SELECT
                ursprung AS dokument_t_id
            FROM 
                arp_npl.rechtsvorschrften_hinweisweiteredokumente

            UNION

            SELECT
                hinweis AS dokument_t_id
            FROM 
                arp_npl.rechtsvorschrften_hinweisweiteredokumente
        ) AS dokumente_1
        LEFT JOIN json_documents_all AS dokumente_2
            ON dokumente_1.dokument_t_id = dokumente_2.t_id
),
typ_grundnutzung_dokument_ref AS (
    SELECT DISTINCT ON (typ_grundnutzung, dok_referenz)
        typ_grundnutzung,
        dokument,
        dok_referenz
    FROM
        (
            SELECT DISTINCT
                typ_grundnutzung_dokument.typ_grundnutzung,
                dokument,
                unnest(dok_dok_referenzen) AS dok_referenz
            FROM
                arp_npl.nutzungsplanung_typ_grundnutzung_dokument AS typ_grundnutzung_dokument
                LEFT JOIN doc_doc_references
                    ON typ_grundnutzung_dokument.dokument = doc_doc_references.ursprung

            UNION

            SELECT
                typ_grundnutzung,
                dokument,
                dokument AS dok_referenz
            FROM
                arp_npl.nutzungsplanung_typ_grundnutzung_dokument
        ) AS subquery
),
typ_grundnutzung_json_dokument AS (
    SELECT
        typ_grundnutzung,
        dokument,
        dok_referenz,
        t_id,
        json_dokument
    FROM
        typ_grundnutzung_dokument_ref
        LEFT JOIN json_documents_all
            ON json_documents_all.t_id = typ_grundnutzung_dokument_ref.dok_referenz
),
typ_grundnutzung_json_dokument_agg AS (
    SELECT
        typ_grundnutzung_t_id,
        '[' || dokumente::varchar || ']' as dokumente
    FROM
        (
            SELECT
                typ_grundnutzung AS typ_grundnutzung_t_id,
                string_agg(json_dokument, ',') AS dokumente
            FROM
                typ_grundnutzung_json_dokument
            GROUP BY
                typ_grundnutzung
        ) as subquery
),
grundnutzung_geometrie_typ AS(
    SELECT
        grundnutzung.t_id,
        grundnutzung.t_datasetname::int4 AS bfs_nr,
        grundnutzung.t_ili_tid,
        grundnutzung.name_nummer,
        grundnutzung.rechtsstatus,
        grundnutzung.publiziertab,
        grundnutzung.bemerkungen,
        grundnutzung.erfasser,
        grundnutzung.datum,
        grundnutzung.geometrie,
        typ.t_id AS typ_t_id,
        typ.typ_kt AS typ_typ_kt,
        typ.code_kommunal AS typ_code_kommunal,
        typ.nutzungsziffer AS typ_nutzungsziffer,
        typ.nutzungsziffer_art AS typ_nutzungsziffer_art,
        typ.geschosszahl AS typ_geschosszahl,
        typ.bezeichnung AS typ_bezeichnung,
        typ.abkuerzung AS typ_abkuerzung,
        typ.verbindlichkeit AS typ_verbindlichkeit,
        typ.bemerkungen AS typ_bemerkungen 
    FROM
        arp_npl.nutzungsplanung_grundnutzung AS grundnutzung
        LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung AS typ
            ON grundnutzung.typ_grundnutzung = typ.t_id
), documents AS (
    SELECT DISTINCT
        titel,
        publiziertAb,
        bemerkung,
        richtplankarte_grundnutzung.t_id AS grundnutzung_id,
        dateipfad AS dokumente
    FROM 
        arp_richtplan.richtplankarte_grundnutzung_dokument
        LEFT JOIN arp_richtplan.richtplankarte_dokument
            ON richtplankarte_dokument.t_id = richtplankarte_grundnutzung_dokument.dokument
        RIGHT JOIN arp_richtplan.richtplankarte_grundnutzung
            ON richtplankarte_grundnutzung_dokument.grundnutzung = richtplankarte_grundnutzung.t_id
    WHERE
        (titel, publiziertab, bemerkung, dateipfad) IS NOT NULL
), documents_json AS (
    SELECT 
        array_to_json(array_agg(row_to_json(documents)))::text AS dokumente, 
        grundnutzung_id
    FROM 
        documents
    GROUP BY 
        grundnutzung_id
)

SELECT
    richtplankarte_grundnutzung.t_ili_tid,
    richtplankarte_grundnutzung.abstimmungskategorie,
    richtplankarte_grundnutzung.grundnutzungsart,
    richtplankarte_grundnutzung.planungsstand,
    richtplankarte_grundnutzung.geometrie,
    documents_json.dokumente AS dokumente
FROM
    arp_richtplan.richtplankarte_grundnutzung
    LEFT JOIN documents_json
        ON documents_json.grundnutzung_id = richtplankarte_grundnutzung.t_id

UNION

SELECT
    grundnutzung.t_ili_tid,
    'Ausgangslage' AS abstimmungskategorie,
    CASE
        WHEN grundnutzung.typ_typ_kt IN ('')
            THEN 'Gewaesser'
        WHEN grundnutzung.typ_typ_kt IN ('')
            THEN 'Nationalstrasse'
        WHEN grundnutzung.typ_typ_kt IN ('')
            THEN 'Wald'
        WHEN grundnutzung.typ_typ_kt IN ('')
            THEN 'Landwirtschaftsgebiet'
        WHEN grundnutzung.typ_typ_kt IN ('')
            THEN 'Siedlungsgebiet.Wohnen_oeffentliche_Bauten'
        WHEN grundnutzung.typ_typ_kt IN ('')
            THEN 'Siedlungsgebiet.Industrie_Arbeiten'
        WHEN grundnutzung.typ_typ_kt IN (
            'N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone',
            'N431_Reservezone_Arbeiten',
            'N432_Reservezone_OeBA',
            'N439_Reservezone')
                THEN 'Reservezone'
    END AS grundnutzungsart,
    'rechtsgueltig' AS planungsstand,
    grundnutzung.geometrie,
    dokumente.dokumente AS dok_id
FROM  
    grundnutzung_geometrie_typ AS grundnutzung 
    LEFT JOIN typ_grundnutzung_json_dokument_agg AS dokumente
        ON grundnutzung.typ_t_id = dokumente.typ_grundnutzung_t_id
WHERE
    grundnutzung.typ_typ_kt IN (
        'N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone',
        'N431_Reservezone_Arbeiten',
        'N432_Reservezone_OeBA',
        'N439_Reservezone')