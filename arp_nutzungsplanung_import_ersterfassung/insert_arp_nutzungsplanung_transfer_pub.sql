-- Datenumbau ins Modell SO_ARP_Nutzungsplanung_Publikation_20201005.ili
-- dataset
INSERT INTO arp_nutzungsplanung_transfer_pub_v1.t_ili2db_dataset
SELECT
    t_id,
    datasetname
FROM
    arp_nutzungsplanung_transfer_v1.t_ili2db_dataset
WHERE
   datasetname::int4 = ${bfsnr_param}
;

-- basket
INSERT INTO arp_nutzungsplanung_transfer_pub_v1.t_ili2db_basket
SELECT
    basket.t_id,
    basket.dataset,
    replace (basket.topic, 'SO_ARP_Nutzungsplanung_Nachfuehrung_20201005', 'SO_ARP_Nutzungsplanung_Publikation_20201005')AS topic,
    basket.t_ili_tid,
    basket.attachmentkey,
    basket.domains
FROM
    arp_nutzungsplanung_transfer_v1.t_ili2db_basket AS basket
    LEFT JOIN arp_nutzungsplanung_transfer_v1.t_ili2db_dataset AS dataset
    ON basket.dataset=dataset.t_id
WHERE
    topic = 'SO_ARP_Nutzungsplanung_Nachfuehrung_20201005.Nutzungsplanung'
AND
    dataset.datasetname::int4 = ${bfsnr_param}
;

--Grundnutzung
WITH dokumente AS (
    SELECT
        t_id,
        dokumentid,
        titel,
        offiziellertitel,
        abkuerzung,
        offiziellenr,
        kanton,
        gemeinde,
        publiziertab,
        rechtsstatus,
        textimweb,
        bemerkungen,
        rechtsvorschrift,
        publiziertbis
    FROM
        arp_nutzungsplanung_transfer_v1.rechtsvorschrften_dokument
    WHERE
        t_datasetname::int4=${bfsnr_param}
    AND
        publiziertbis IS NULL
),
json_documents AS (
    SELECT
  (
    row_to_json
    ((
        SELECT
            docs
        FROM
        (
            SELECT
                dokumentid AS "DokumentID",
                titel AS "Titel",
                offiziellertitel AS "OffiziellerTitel",
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "OffizielleNr",
                kanton AS "Kanton",
                gemeinde AS "Gemeinde",
                publiziertab AS "publiziertAb",
                rechtsstatus AS "Rechtsstatus",
                textimweb AS "TextimWeb",
                bemerkungen AS "Bemerkungen",
                rechtsvorschrift AS "Rechtsvorschrift",
                publiziertbis AS "publiziertBis",
                'SO_ARP_Nutzungsplanung_Publikation_20201005.Nutzungsplanung.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        dokumente
),

typ_grundnutzung_json_dokument_agg AS (
    SELECT
        typ_grundnutzung_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_grundnutzung.typ_grundnutzung AS typ_grundnutzung_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_grundnutzung_dokument AS dokument_grundnutzung
            ON dokument_grundnutzung.dokument = json_documents.t_id
        GROUP BY
        dokument_grundnutzung.typ_grundnutzung
    ) AS a
),

grundnutzung AS (
    SELECT
        grundnutzung.t_id,
        grundnutzung.t_ili_tid,
        typ.bezeichnung AS typ_bezeichnung,
        typ.abkuerzung AS typ_abkuerzung,
        typ.verbindlichkeit AS typ_verbindlichkeit,
        typ.bemerkungen AS typ_bemerkungen,
        typ.typ_kt,
        typ.code_kommunal AS typ_code_kommunal,
        typ.nutzungsziffer AS typ_nutzungsziffer,
        typ.nutzungsziffer_art AS typ_nutzungsziffer_art,
        typ.geschosszahl AS typ_geschosszahl,
        typ.t_id AS typ_t_id,
        grundnutzung.geometrie,
        grundnutzung.geschaefts_nummer,
        grundnutzung.rechtsstatus,
        grundnutzung.publiziertab,
        grundnutzung.bemerkungen,
        grundnutzung.erfasser,
        grundnutzung.datum AS datum_erfassung,
        grundnutzung.t_datasetname AS bfs_nr,
        grundnutzung.publiziertbis,
        substring(typ.typ_kt,2,3)::int4 AS typ_code_kt,
        substring(typ.typ_kt,2,2)::int4  AS typ_code_ch
    FROM
        arp_nutzungsplanung_transfer_v1.nutzungsplanung_grundnutzung AS grundnutzung
        LEFT JOIN arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_grundnutzung AS typ
        ON grundnutzung.typ_grundnutzung = typ.t_id
    WHERE
        grundnutzung.t_datasetname::int4=${bfsnr_param}
    AND
        grundnutzung.publiziertbis IS NULL
)

INSERT INTO arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_grundnutzung
SELECT
    grundnutzung.t_id,
    grundnutzung.t_ili_tid,
    grundnutzung.typ_bezeichnung,
    grundnutzung.typ_abkuerzung,
    grundnutzung.typ_verbindlichkeit,
    grundnutzung.typ_bemerkungen,
    grundnutzung.typ_kt,
    grundnutzung.typ_code_kommunal::int4,
    grundnutzung.typ_nutzungsziffer,
    grundnutzung.typ_nutzungsziffer_art,
    grundnutzung.typ_geschosszahl,
    grundnutzung.geometrie,
    grundnutzung.geschaefts_nummer,
    grundnutzung.rechtsstatus,
    grundnutzung.publiziertab,
    grundnutzung.bemerkungen,
    grundnutzung.erfasser,
    grundnutzung.datum_erfassung,
    typ_grundnutzung_json_dokument_agg.dokumente::json AS dokumente,
    ${bfsnr_param} AS bfs_nr,
    grundnutzung.publiziertbis,
    substring(grundnutzung.typ_kt,2,3)::int4 AS typ_code_kt,
    substring(grundnutzung.typ_kt,2,2)::int4  AS typ_code_ch
FROM
    grundnutzung
    LEFT JOIN typ_grundnutzung_json_dokument_agg
    ON grundnutzung.typ_t_id= typ_grundnutzung_json_dokument_agg.typ_grundnutzung_t_id
;
--überlagernd Fläche
WITH dokumente AS (
    SELECT
        t_id,
        dokumentid,
        titel,
        offiziellertitel,
        abkuerzung,
        offiziellenr,
        kanton,
        gemeinde,
        publiziertab,
        rechtsstatus,
        textimweb,
        bemerkungen,
        rechtsvorschrift,
        publiziertbis
    FROM
        arp_nutzungsplanung_transfer_v1.rechtsvorschrften_dokument
    WHERE
        t_datasetname::int4=${bfsnr_param}
    AND
        publiziertbis IS NULL
),
json_documents AS (
    SELECT
  (
    row_to_json
    ((
        SELECT
            docs
        FROM
        (
            SELECT
                dokumentid AS "DokumentID",
                titel AS "Titel",
                offiziellertitel AS "OffiziellerTitel",
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "OffizielleNr",
                kanton AS "Kanton",
                gemeinde AS "Gemeinde",
                publiziertab AS "publiziertAb",
                rechtsstatus AS "Rechtsstatus",
                textimweb AS "TextimWeb",
                bemerkungen AS "Bemerkungen",
                rechtsvorschrift AS "Rechtsvorschrift",
                publiziertbis AS "publiziertBis",
                'SO_ARP_Nutzungsplanung_Publikation_20201005.Nutzungsplanung.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        dokumente
),

typ_ueberlagernd_flaeche_json_dokument_agg AS (
    SELECT
        typ_ueberlagernd_flaeche_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_ueberlagernd_flaeche.typ_ueberlagernd_flaeche AS typ_ueberlagernd_flaeche_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_flaeche_dokument AS dokument_ueberlagernd_flaeche
            ON dokument_ueberlagernd_flaeche.dokument = json_documents.t_id
        GROUP BY
        dokument_ueberlagernd_flaeche.typ_ueberlagernd_flaeche
    ) AS a
),

ueberlagernd_flaeche AS (
    SELECT
        ueberlagernd_flaeche.t_id,
        ueberlagernd_flaeche.t_ili_tid,
        typ.bezeichnung AS typ_bezeichnung,
        typ.abkuerzung AS typ_abkuerzung,
        typ.verbindlichkeit AS typ_verbindlichkeit,
        typ.bemerkungen AS typ_bemerkungen,
        typ.typ_kt,
        typ.code_kommunal AS typ_code_kommunal,
        typ.t_id AS typ_t_id,
        ueberlagernd_flaeche.geometrie,
        ueberlagernd_flaeche.geschaefts_nummer,
        ueberlagernd_flaeche.rechtsstatus,
        ueberlagernd_flaeche.publiziertab,
        ueberlagernd_flaeche.bemerkungen,
        ueberlagernd_flaeche.erfasser,
        ueberlagernd_flaeche.datum AS datum_erfassung,
        ueberlagernd_flaeche.t_datasetname AS bfs_nr,
        ueberlagernd_flaeche.publiziertbis,
        substring(typ.typ_kt,2,3)::int4 AS typ_code_kt,
        substring(typ.typ_kt,2,2)::int4  AS typ_code_ch
    FROM
        arp_nutzungsplanung_transfer_v1.nutzungsplanung_ueberlagernd_flaeche AS ueberlagernd_flaeche
        LEFT JOIN arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_flaeche AS typ
        ON ueberlagernd_flaeche.typ_ueberlagernd_flaeche= typ.t_id
    WHERE
        ueberlagernd_flaeche.t_datasetname::int4=${bfsnr_param}
    AND
        ueberlagernd_flaeche.publiziertbis IS NULL
)

INSERT INTO arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_ueberlagernd_flaeche
SELECT
    ueberlagernd_flaeche.t_id,
    ueberlagernd_flaeche.t_ili_tid,
    ueberlagernd_flaeche.typ_bezeichnung,
    ueberlagernd_flaeche.typ_abkuerzung,
    ueberlagernd_flaeche.typ_verbindlichkeit,
    ueberlagernd_flaeche.typ_bemerkungen,
    ueberlagernd_flaeche.typ_kt,
    ueberlagernd_flaeche.typ_code_kommunal::int4,
    ueberlagernd_flaeche.geometrie,
    ueberlagernd_flaeche.geschaefts_nummer,
    ueberlagernd_flaeche.rechtsstatus,
    ueberlagernd_flaeche.publiziertab,
    ueberlagernd_flaeche.bemerkungen,
    ueberlagernd_flaeche.erfasser,
    ueberlagernd_flaeche.datum_erfassung,
    typ_ueberlagernd_flaeche_json_dokument_agg.dokumente::json AS dokumente,
    ${bfsnr_param} AS bfs_nr,
    ueberlagernd_flaeche.publiziertbis,
    substring(ueberlagernd_flaeche.typ_kt,2,3)::int4 AS typ_code_kt,
    substring(ueberlagernd_flaeche.typ_kt,2,2)::int4  AS typ_code_ch
FROM
    ueberlagernd_flaeche
    LEFT JOIN typ_ueberlagernd_flaeche_json_dokument_agg
    ON ueberlagernd_flaeche.typ_t_id= typ_ueberlagernd_flaeche_json_dokument_agg.typ_ueberlagernd_flaeche_t_id
;

--überlagernd Linie
WITH dokumente AS (
    SELECT
        t_id,
        dokumentid,
        titel,
        offiziellertitel,
        abkuerzung,
        offiziellenr,
        kanton,
        gemeinde,
        publiziertab,
        rechtsstatus,
        textimweb,
        bemerkungen,
        rechtsvorschrift,
        publiziertbis
    FROM
        arp_nutzungsplanung_transfer_v1.rechtsvorschrften_dokument
    WHERE
        t_datasetname::int4=${bfsnr_param}
    AND
        publiziertbis IS NULL
),
json_documents AS (
    SELECT
  (
    row_to_json
    ((
        SELECT
            docs
        FROM
        (
            SELECT
                dokumentid AS "DokumentID",
                titel AS "Titel",
                offiziellertitel AS "OffiziellerTitel",
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "OffizielleNr",
                kanton AS "Kanton",
                gemeinde AS "Gemeinde",
                publiziertab AS "publiziertAb",
                rechtsstatus AS "Rechtsstatus",
                textimweb AS "TextimWeb",
                bemerkungen AS "Bemerkungen",
                rechtsvorschrift AS "Rechtsvorschrift",
                publiziertbis AS "publiziertBis",
                'SO_ARP_Nutzungsplanung_Publikation_20201005.Nutzungsplanung.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        dokumente
),

typ_ueberlagernd_linie_json_dokument_agg AS (
    SELECT
        typ_ueberlagernd_linie_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_ueberlagernd_linie.typ_ueberlagernd_linie AS typ_ueberlagernd_linie_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_linie_dokument AS dokument_ueberlagernd_linie
            ON dokument_ueberlagernd_linie.dokument = json_documents.t_id
        GROUP BY
        dokument_ueberlagernd_linie.typ_ueberlagernd_linie
    ) AS a
),

ueberlagernd_linie AS (
    SELECT
        ueberlagernd_linie.t_id,
        ueberlagernd_linie.t_ili_tid,
        typ.bezeichnung AS typ_bezeichnung,
        typ.abkuerzung AS typ_abkuerzung,
        typ.verbindlichkeit AS typ_verbindlichkeit,
        typ.bemerkungen AS typ_bemerkungen,
        typ.typ_kt,
        typ.code_kommunal AS typ_code_kommunal,
        typ.t_id AS typ_t_id,
        ueberlagernd_linie.geometrie,
        ueberlagernd_linie.geschaefts_nummer,
        ueberlagernd_linie.rechtsstatus,
        ueberlagernd_linie.publiziertab,
        ueberlagernd_linie.bemerkungen,
        ueberlagernd_linie.erfasser,
        ueberlagernd_linie.datum AS datum_erfassung,
        ueberlagernd_linie.t_datasetname AS bfs_nr,
        ueberlagernd_linie.publiziertbis,
        substring(typ.typ_kt,2,3)::int4 AS typ_code_kt,
        substring(typ.typ_kt,2,2)::int4  AS typ_code_ch
    FROM
        arp_nutzungsplanung_transfer_v1.nutzungsplanung_ueberlagernd_linie AS ueberlagernd_linie
        LEFT JOIN arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_linie AS typ
        ON ueberlagernd_linie.typ_ueberlagernd_linie= typ.t_id
    WHERE
        ueberlagernd_linie.t_datasetname::int4=${bfsnr_param}
    AND
        ueberlagernd_linie.publiziertbis IS NULL
)

INSERT INTO arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_ueberlagernd_linie
SELECT
    ueberlagernd_linie.t_id,
    ueberlagernd_linie.t_ili_tid,
    ueberlagernd_linie.typ_bezeichnung,
    ueberlagernd_linie.typ_abkuerzung,
    ueberlagernd_linie.typ_verbindlichkeit,
    ueberlagernd_linie.typ_bemerkungen,
    ueberlagernd_linie.typ_kt,
    ueberlagernd_linie.typ_code_kommunal::int4,
    ueberlagernd_linie.geometrie,
    ueberlagernd_linie.geschaefts_nummer,
    ueberlagernd_linie.rechtsstatus,
    ueberlagernd_linie.publiziertab,
    ueberlagernd_linie.bemerkungen,
    ueberlagernd_linie.erfasser,
    ueberlagernd_linie.datum_erfassung,
    typ_ueberlagernd_linie_json_dokument_agg.dokumente::json AS dokumente,
    ${bfsnr_param} AS bfs_nr,
    ueberlagernd_linie.publiziertbis,
    substring(ueberlagernd_linie.typ_kt,2,3)::int4 AS typ_code_kt,
    substring(ueberlagernd_linie.typ_kt,2,2)::int4  AS typ_code_ch
FROM
    ueberlagernd_linie
    LEFT JOIN typ_ueberlagernd_linie_json_dokument_agg
    ON ueberlagernd_linie.typ_t_id= typ_ueberlagernd_linie_json_dokument_agg.typ_ueberlagernd_linie_t_id
;

--überlagernd Punkt
WITH dokumente AS (
    SELECT
        t_id,
        dokumentid,
        titel,
        offiziellertitel,
        abkuerzung,
        offiziellenr,
        kanton,
        gemeinde,
        publiziertab,
        rechtsstatus,
        textimweb,
        bemerkungen,
        rechtsvorschrift,
        publiziertbis
    FROM
        arp_nutzungsplanung_transfer_v1.rechtsvorschrften_dokument
    WHERE
        t_datasetname::int4=${bfsnr_param}
    AND
        publiziertbis IS NULL
),

json_documents AS (
    SELECT
  (
    row_to_json
    ((
        SELECT
            docs
        FROM
        (
            SELECT
                dokumentid AS "DokumentID",
                titel AS "Titel",
                offiziellertitel AS "OffiziellerTitel",
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "OffizielleNr",
                kanton AS "Kanton",
                gemeinde AS "Gemeinde",
                publiziertab AS "publiziertAb",
                rechtsstatus AS "Rechtsstatus",
                textimweb AS "TextimWeb",
                bemerkungen AS "Bemerkungen",
                rechtsvorschrift AS "Rechtsvorschrift",
                publiziertbis AS "publiziertBis",
                'SO_ARP_Nutzungsplanung_Publikation_20201005.Nutzungsplanung.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        dokumente
),

typ_ueberlagernd_punkt_json_dokument_agg AS (
    SELECT
        typ_ueberlagernd_punkt_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_ueberlagernd_punkt.typ_ueberlagernd_punkt AS typ_ueberlagernd_punkt_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_punkt_dokument AS dokument_ueberlagernd_punkt
            ON dokument_ueberlagernd_punkt.dokument = json_documents.t_id
        GROUP BY
        dokument_ueberlagernd_punkt.typ_ueberlagernd_punkt
    ) AS a
),

ueberlagernd_punkt AS (
    SELECT
        ueberlagernd_punkt.t_id,
        ueberlagernd_punkt.t_ili_tid,
        typ.bezeichnung AS typ_bezeichnung,
        typ.abkuerzung AS typ_abkuerzung,
        typ.verbindlichkeit AS typ_verbindlichkeit,
        typ.bemerkungen AS typ_bemerkungen,
        typ.typ_kt,
        typ.code_kommunal AS typ_code_kommunal,
        typ.t_id AS typ_t_id,
        ueberlagernd_punkt.geometrie,
        ueberlagernd_punkt.geschaefts_nummer,
        ueberlagernd_punkt.rechtsstatus,
        ueberlagernd_punkt.publiziertab,
        ueberlagernd_punkt.bemerkungen,
        ueberlagernd_punkt.erfasser,
        ueberlagernd_punkt.datum AS datum_erfassung,
        ueberlagernd_punkt.t_datasetname AS bfs_nr,
        ueberlagernd_punkt.publiziertbis,
        substring(typ.typ_kt,2,3)::int4 AS typ_code_kt,
        substring(typ.typ_kt,2,2)::int4  AS typ_code_ch
    FROM
        arp_nutzungsplanung_transfer_v1.nutzungsplanung_ueberlagernd_punkt AS ueberlagernd_punkt
        LEFT JOIN arp_nutzungsplanung_transfer_v1.nutzungsplanung_typ_ueberlagernd_punkt AS typ
        ON ueberlagernd_punkt.typ_ueberlagernd_punkt= typ.t_id
    WHERE
        ueberlagernd_punkt.t_datasetname::int4=${bfsnr_param}
    AND
        ueberlagernd_punkt.publiziertbis IS NULL
)

INSERT INTO arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_ueberlagernd_punkt
SELECT
    ueberlagernd_punkt.t_id,
    ueberlagernd_punkt.t_ili_tid,
    ueberlagernd_punkt.typ_bezeichnung,
    ueberlagernd_punkt.typ_abkuerzung,
    ueberlagernd_punkt.typ_verbindlichkeit,
    ueberlagernd_punkt.typ_bemerkungen,
    ueberlagernd_punkt.typ_kt,
    ueberlagernd_punkt.typ_code_kommunal::int4,
    ueberlagernd_punkt.geometrie,
    ueberlagernd_punkt.geschaefts_nummer,
    ueberlagernd_punkt.rechtsstatus,
    ueberlagernd_punkt.publiziertab,
    ueberlagernd_punkt.bemerkungen,
    ueberlagernd_punkt.erfasser,
    ueberlagernd_punkt.datum_erfassung,
    typ_ueberlagernd_punkt_json_dokument_agg.dokumente::json AS dokumente,
    ${bfsnr_param} AS bfs_nr,
    ueberlagernd_punkt.publiziertbis,
    substring(ueberlagernd_punkt.typ_kt,2,3)::int4 AS typ_code_kt,
    substring(ueberlagernd_punkt.typ_kt,2,2)::int4  AS typ_code_ch
FROM
    ueberlagernd_punkt
    LEFT JOIN typ_ueberlagernd_punkt_json_dokument_agg
    ON ueberlagernd_punkt.typ_t_id= typ_ueberlagernd_punkt_json_dokument_agg.typ_ueberlagernd_punkt_t_id
;


--Erschliesung Fläche
WITH dokumente AS (
    SELECT
        t_id,
        dokumentid,
        titel,
        offiziellertitel,
        abkuerzung,
        offiziellenr,
        kanton,
        gemeinde,
        publiziertab,
        rechtsstatus,
        textimweb,
        bemerkungen,
        rechtsvorschrift,
        publiziertbis
    FROM
        arp_nutzungsplanung_transfer_v1.rechtsvorschrften_dokument
    WHERE
        t_datasetname::int4=${bfsnr_param}
    AND
        publiziertbis IS NULL
),
json_documents AS (
    SELECT
  (
    row_to_json
    ((
        SELECT
            docs
        FROM
        (
            SELECT
                dokumentid AS "DokumentID",
                titel AS "Titel",
                offiziellertitel AS "OffiziellerTitel",
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "OffizielleNr",
                kanton AS "Kanton",
                gemeinde AS "Gemeinde",
                publiziertab AS "publiziertAb",
                rechtsstatus AS "Rechtsstatus",
                textimweb AS "TextimWeb",
                bemerkungen AS "Bemerkungen",
                rechtsvorschrift AS "Rechtsvorschrift",
                publiziertbis AS "publiziertBis",
                'SO_ARP_Nutzungsplanung_Publikation_20201005.Nutzungsplanung.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        dokumente
),

typ_erschliessung_flaechenobjekt_json_dokument_agg AS (
    SELECT
        typ_erschliessung_flaechenobjekt_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_erschliessung_flaechenobjekt.typ_erschliessung_flaechenobjekt AS typ_erschliessung_flaechenobjekt_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt_dokument AS dokument_erschliessung_flaechenobjekt
            ON dokument_erschliessung_flaechenobjekt.dokument = json_documents.t_id
        GROUP BY
        dokument_erschliessung_flaechenobjekt.typ_erschliessung_flaechenobjekt
    ) AS a
),

erschliessung_flaechenobjekt AS (
    SELECT
        erschliessung_flaechenobjekt.t_id,
        erschliessung_flaechenobjekt.t_ili_tid,
        typ.bezeichnung AS typ_bezeichnung,
        typ.abkuerzung AS typ_abkuerzung,
        typ.verbindlichkeit AS typ_verbindlichkeit,
        typ.bemerkungen AS typ_bemerkungen,
        typ.typ_kt,
        typ.code_kommunal AS typ_code_kommunal,
        typ.t_id AS typ_t_id,
        erschliessung_flaechenobjekt.geometrie,
        erschliessung_flaechenobjekt.geschaefts_nummer,
        erschliessung_flaechenobjekt.rechtsstatus,
        erschliessung_flaechenobjekt.publiziertab,
        erschliessung_flaechenobjekt.bemerkungen,
        erschliessung_flaechenobjekt.erfasser,
        erschliessung_flaechenobjekt.datum AS datum_erfassung,
        erschliessung_flaechenobjekt.t_datasetname AS bfs_nr,
        erschliessung_flaechenobjekt.publiziertbis,
        substring(typ.typ_kt,2,3)::int4 AS typ_code_kt,
        substring(typ.typ_kt,2,2)::int4  AS typ_code_ch
    FROM
        arp_nutzungsplanung_transfer_v1.erschlssngsplnung_erschliessung_flaechenobjekt AS erschliessung_flaechenobjekt
        LEFT JOIN arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt AS typ
        ON erschliessung_flaechenobjekt.typ_erschliessung_flaechenobjekt= typ.t_id
    WHERE
        erschliessung_flaechenobjekt.t_datasetname::int4=${bfsnr_param}
    AND
        erschliessung_flaechenobjekt.publiziertbis IS NULL
)

INSERT INTO arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_erschliessung_flaechenobjekt
SELECT
    erschliessung_flaechenobjekt.t_id,
    erschliessung_flaechenobjekt.t_ili_tid,
    erschliessung_flaechenobjekt.typ_bezeichnung,
    erschliessung_flaechenobjekt.typ_abkuerzung,
    erschliessung_flaechenobjekt.typ_verbindlichkeit,
    erschliessung_flaechenobjekt.typ_bemerkungen,
    erschliessung_flaechenobjekt.typ_kt,
    erschliessung_flaechenobjekt.typ_code_kommunal::int4,
    erschliessung_flaechenobjekt.geometrie,
    erschliessung_flaechenobjekt.geschaefts_nummer,
    erschliessung_flaechenobjekt.rechtsstatus,
    erschliessung_flaechenobjekt.publiziertab,
    erschliessung_flaechenobjekt.bemerkungen,
    erschliessung_flaechenobjekt.erfasser,
    erschliessung_flaechenobjekt.datum_erfassung,
    typ_erschliessung_flaechenobjekt_json_dokument_agg.dokumente::json AS dokumente,
    ${bfsnr_param} AS bfs_nr,
    erschliessung_flaechenobjekt.publiziertbis,
    substring(erschliessung_flaechenobjekt.typ_kt,2,3)::int4 AS typ_code_kt,
    substring(erschliessung_flaechenobjekt.typ_kt,2,2)::int4  AS typ_code_ch
FROM
    erschliessung_flaechenobjekt
    LEFT JOIN typ_erschliessung_flaechenobjekt_json_dokument_agg
    ON erschliessung_flaechenobjekt.typ_t_id= typ_erschliessung_flaechenobjekt_json_dokument_agg.typ_erschliessung_flaechenobjekt_t_id
;

--Erschliesung Linie
WITH dokumente AS (
    SELECT
        t_id,
        dokumentid,
        titel,
        offiziellertitel,
        abkuerzung,
        offiziellenr,
        kanton,
        gemeinde,
        publiziertab,
        rechtsstatus,
        textimweb,
        bemerkungen,
        rechtsvorschrift,
        publiziertbis
    FROM
        arp_nutzungsplanung_transfer_v1.rechtsvorschrften_dokument
    WHERE
        t_datasetname::int4=${bfsnr_param}
    AND
        publiziertbis IS NULL
),
json_documents AS (
    SELECT
  (
    row_to_json
    ((
        SELECT
            docs
        FROM
        (
            SELECT
                dokumentid AS "DokumentID",
                titel AS "Titel",
                offiziellertitel AS "OffiziellerTitel",
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "OffizielleNr",
                kanton AS "Kanton",
                gemeinde AS "Gemeinde",
                publiziertab AS "publiziertAb",
                rechtsstatus AS "Rechtsstatus",
                textimweb AS "TextimWeb",
                bemerkungen AS "Bemerkungen",
                rechtsvorschrift AS "Rechtsvorschrift",
                publiziertbis AS "publiziertBis",
                'SO_ARP_Nutzungsplanung_Publikation_20201005.Nutzungsplanung.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        dokumente
),

typ_erschliessung_linienobjekt_json_dokument_agg AS (
    SELECT
        typ_erschliessung_linienobjekt_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_erschliessung_linienobjekt.typ_erschliessung_linienobjekt AS typ_erschliessung_linienobjekt_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument AS dokument_erschliessung_linienobjekt
            ON dokument_erschliessung_linienobjekt.dokument = json_documents.t_id
        GROUP BY
        dokument_erschliessung_linienobjekt.typ_erschliessung_linienobjekt
    ) AS a
),

erschliessung_linienobjekt AS (
    SELECT
        erschliessung_linienobjekt.t_id,
        erschliessung_linienobjekt.t_ili_tid,
        typ.bezeichnung AS typ_bezeichnung,
        typ.abkuerzung AS typ_abkuerzung,
        typ.verbindlichkeit AS typ_verbindlichkeit,
        typ.bemerkungen AS typ_bemerkungen,
        typ.typ_kt,
        typ.code_kommunal AS typ_code_kommunal,
        typ.t_id AS typ_t_id,
        erschliessung_linienobjekt.geometrie,
        erschliessung_linienobjekt.geschaefts_nummer,
        erschliessung_linienobjekt.rechtsstatus,
        erschliessung_linienobjekt.publiziertab,
        erschliessung_linienobjekt.bemerkungen,
        erschliessung_linienobjekt.erfasser,
        erschliessung_linienobjekt.datum AS datum_erfassung,
        erschliessung_linienobjekt.t_datasetname AS bfs_nr,
        erschliessung_linienobjekt.publiziertbis,
        substring(typ.typ_kt,2,3)::int4 AS typ_code_kt,
        substring(typ.typ_kt,2,2)::int4  AS typ_code_ch
    FROM
        arp_nutzungsplanung_transfer_v1.erschlssngsplnung_erschliessung_linienobjekt AS erschliessung_linienobjekt
        LEFT JOIN arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_linienobjekt AS typ
        ON erschliessung_linienobjekt.typ_erschliessung_linienobjekt= typ.t_id
    WHERE
        erschliessung_linienobjekt.t_datasetname::int4=${bfsnr_param}
    AND
        erschliessung_linienobjekt.publiziertbis IS NULL
)

INSERT INTO arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_erschliessung_linienobjekt
SELECT
    erschliessung_linienobjekt.t_id,
    erschliessung_linienobjekt.t_ili_tid,
    erschliessung_linienobjekt.typ_bezeichnung,
    erschliessung_linienobjekt.typ_abkuerzung,
    erschliessung_linienobjekt.typ_verbindlichkeit,
    erschliessung_linienobjekt.typ_bemerkungen,
    erschliessung_linienobjekt.typ_kt,
    erschliessung_linienobjekt.typ_code_kommunal::int4,
    erschliessung_linienobjekt.geometrie,
    erschliessung_linienobjekt.geschaefts_nummer,
    erschliessung_linienobjekt.rechtsstatus,
    erschliessung_linienobjekt.publiziertab,
    erschliessung_linienobjekt.bemerkungen,
    erschliessung_linienobjekt.erfasser,
    erschliessung_linienobjekt.datum_erfassung,
    typ_erschliessung_linienobjekt_json_dokument_agg.dokumente::json AS dokumente,
    ${bfsnr_param} AS bfs_nr,
    erschliessung_linienobjekt.publiziertbis,
    substring(erschliessung_linienobjekt.typ_kt,2,3)::int4 AS typ_code_kt,
    substring(erschliessung_linienobjekt.typ_kt,2,2)::int4  AS typ_code_ch
FROM
    erschliessung_linienobjekt
    LEFT JOIN typ_erschliessung_linienobjekt_json_dokument_agg
    ON erschliessung_linienobjekt.typ_t_id= typ_erschliessung_linienobjekt_json_dokument_agg.typ_erschliessung_linienobjekt_t_id
;
-- Erschliesung Punkt
WITH dokumente AS (
    SELECT
        t_id,
        dokumentid,
        titel,
        offiziellertitel,
        abkuerzung,
        offiziellenr,
        kanton,
        gemeinde,
        publiziertab,
        rechtsstatus,
        textimweb,
        bemerkungen,
        rechtsvorschrift,
        publiziertbis
    FROM
        arp_nutzungsplanung_transfer_v1.rechtsvorschrften_dokument
    WHERE
        t_datasetname::int4=${bfsnr_param}
    AND
        publiziertbis IS NULL
),
json_documents AS (
    SELECT
  (
    row_to_json
    ((
        SELECT
            docs
        FROM
        (
            SELECT
                dokumentid AS "DokumentID",
                titel AS "Titel",
                offiziellertitel AS "OffiziellerTitel",
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "OffizielleNr",
                kanton AS "Kanton",
                gemeinde AS "Gemeinde",
                publiziertab AS "publiziertAb",
                rechtsstatus AS "Rechtsstatus",
                textimweb AS "TextimWeb",
                bemerkungen AS "Bemerkungen",
                rechtsvorschrift AS "Rechtsvorschrift",
                publiziertbis AS "publiziertBis",
                'SO_ARP_Nutzungsplanung_Publikation_20201005.Nutzungsplanung.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        dokumente
),

typ_erschliessung_punktobjekt_json_dokument_agg AS (
    SELECT
        typ_erschliessung_punktobjekt_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_erschliessung_punktobjekt.typ_erschliessung_punktobjekt AS typ_erschliessung_punktobjekt_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_punktobjekt_dokument AS dokument_erschliessung_punktobjekt
            ON dokument_erschliessung_punktobjekt.dokument = json_documents.t_id
        GROUP BY
        dokument_erschliessung_punktobjekt.typ_erschliessung_punktobjekt
    ) AS a
),

erschliessung_punktobjekt AS (
    SELECT
        erschliessung_punktobjekt.t_id,
        erschliessung_punktobjekt.t_ili_tid,
        typ.bezeichnung AS typ_bezeichnung,
        typ.abkuerzung AS typ_abkuerzung,
        typ.verbindlichkeit AS typ_verbindlichkeit,
        typ.bemerkungen AS typ_bemerkungen,
        typ.typ_kt,
        typ.code_kommunal AS typ_code_kommunal,
        typ.t_id AS typ_t_id,
        erschliessung_punktobjekt.geometrie,
        erschliessung_punktobjekt.geschaefts_nummer,
        erschliessung_punktobjekt.rechtsstatus,
        erschliessung_punktobjekt.publiziertab,
        erschliessung_punktobjekt.bemerkungen,
        erschliessung_punktobjekt.erfasser,
        erschliessung_punktobjekt.datum AS datum_erfassung,
        erschliessung_punktobjekt.t_datasetname AS bfs_nr,
        erschliessung_punktobjekt.publiziertbis,
        substring(typ.typ_kt,2,3)::int4 AS typ_code_kt,
        substring(typ.typ_kt,2,2)::int4  AS typ_code_ch
    FROM
        arp_nutzungsplanung_transfer_v1.erschlssngsplnung_erschliessung_punktobjekt AS erschliessung_punktobjekt
        LEFT JOIN arp_nutzungsplanung_transfer_v1.erschlssngsplnung_typ_erschliessung_punktobjekt AS typ
        ON erschliessung_punktobjekt.typ_erschliessung_punktobjekt= typ.t_id
    WHERE
        erschliessung_punktobjekt.t_datasetname::int4=${bfsnr_param}
    AND
        erschliessung_punktobjekt.publiziertbis IS NULL
)

INSERT INTO arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_erschliessung_punktobjekt
SELECT
    erschliessung_punktobjekt.t_id,
    erschliessung_punktobjekt.t_ili_tid,
    erschliessung_punktobjekt.typ_bezeichnung,
    erschliessung_punktobjekt.typ_abkuerzung,
    erschliessung_punktobjekt.typ_verbindlichkeit,
    erschliessung_punktobjekt.typ_bemerkungen,
    erschliessung_punktobjekt.typ_kt,
    erschliessung_punktobjekt.typ_code_kommunal::int4,
    erschliessung_punktobjekt.geometrie,
    erschliessung_punktobjekt.geschaefts_nummer,
    erschliessung_punktobjekt.rechtsstatus,
    erschliessung_punktobjekt.publiziertab,
    erschliessung_punktobjekt.bemerkungen,
    erschliessung_punktobjekt.erfasser,
    erschliessung_punktobjekt.datum_erfassung,
    typ_erschliessung_punktobjekt_json_dokument_agg.dokumente::json AS dokumente,
    ${bfsnr_param} AS bfs_nr,
    erschliessung_punktobjekt.publiziertbis,
    substring(erschliessung_punktobjekt.typ_kt,2,3)::int4 AS typ_code_kt,
    substring(erschliessung_punktobjekt.typ_kt,2,2)::int4  AS typ_code_ch
FROM
    erschliessung_punktobjekt
    LEFT JOIN typ_erschliessung_punktobjekt_json_dokument_agg
    ON erschliessung_punktobjekt.typ_t_id= typ_erschliessung_punktobjekt_json_dokument_agg.typ_erschliessung_punktobjekt_t_id
;
-- Lärmempfindlichkeit
WITH dokumente AS (
    SELECT
        t_id,
        dokumentid,
        titel,
        offiziellertitel,
        abkuerzung,
        offiziellenr,
        kanton,
        gemeinde,
        publiziertab,
        rechtsstatus,
        textimweb,
        bemerkungen,
        rechtsvorschrift,
        publiziertbis
    FROM
        arp_nutzungsplanung_transfer_v1.rechtsvorschrften_dokument
    WHERE
        t_datasetname::int4=${bfsnr_param}
    AND
        publiziertbis IS NULL
),
json_documents AS (
    SELECT
  (
    row_to_json
    ((
        SELECT
            docs
        FROM
        (
            SELECT
                dokumentid AS "DokumentID",
                titel AS "Titel",
                offiziellertitel AS "OffiziellerTitel",
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "OffizielleNr",
                kanton AS "Kanton",
                gemeinde AS "Gemeinde",
                publiziertab AS "publiziertAb",
                rechtsstatus AS "Rechtsstatus",
                textimweb AS "TextimWeb",
                bemerkungen AS "Bemerkungen",
                rechtsvorschrift AS "Rechtsvorschrift",
                publiziertbis AS "publiziertBis",
                'SO_ARP_Nutzungsplanung_Publikation_20201005.Nutzungsplanung.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dok,
        t_id
    FROM
        dokumente
),

typ_empfindlichkeitsstufe_json_dokument_agg AS (
    SELECT
        typ_empfindlichkeitsstufe_t_id,
        '[' || dokumente::varchar || ']' AS dokumente
    FROM
    (
        SELECT
            dokument_empfindlichkeitsstufe.typ_empfindlichkeitsstufen AS typ_empfindlichkeitsstufe_t_id,
            string_agg(json_dok, ',') AS dokumente
        FROM
            json_documents
            LEFT JOIN arp_nutzungsplanung_transfer_v1.laermmpfhktsstfen_typ_empfindlichkeitsstufe_dokument AS dokument_empfindlichkeitsstufe
            ON dokument_empfindlichkeitsstufe.dokument = json_documents.t_id
        GROUP BY
        dokument_empfindlichkeitsstufe.typ_empfindlichkeitsstufen
    ) AS a
),

empfindlichkeitsstufe AS (
    SELECT
        empfindlichkeitsstufe.t_id,
        empfindlichkeitsstufe.t_ili_tid,
        typ.bezeichnung AS typ_bezeichnung,
        typ.abkuerzung AS typ_abkuerzung,
        typ.verbindlichkeit AS typ_verbindlichkeit,
        typ.bemerkungen AS typ_bemerkungen,
        typ.typ_kt,
        typ.t_id AS typ_t_id,
        empfindlichkeitsstufe.geometrie,
        empfindlichkeitsstufe.geschaefts_nummer,
        empfindlichkeitsstufe.rechtsstatus,
        empfindlichkeitsstufe.publiziertab,
        empfindlichkeitsstufe.bemerkungen,
        empfindlichkeitsstufe.erfasser,
        empfindlichkeitsstufe.datum AS datum_erfassung,
        empfindlichkeitsstufe.t_datasetname AS bfs_nr,
        empfindlichkeitsstufe.publiziertbis,
        substring(typ.typ_kt,2,3)::int4 AS typ_code_kt,
        substring(typ.typ_kt,2,2)::int4  AS typ_code_ch
    FROM
        arp_nutzungsplanung_transfer_v1.laermmpfhktsstfen_empfindlichkeitsstufe AS empfindlichkeitsstufe
        LEFT JOIN arp_nutzungsplanung_transfer_v1.laermmpfhktsstfen_typ_empfindlichkeitsstufe AS typ
        ON empfindlichkeitsstufe.typ_empfindlichkeitsstufen= typ.t_id
    WHERE
        empfindlichkeitsstufe.t_datasetname::int4=${bfsnr_param}
    AND
        empfindlichkeitsstufe.publiziertbis IS NULL
)

INSERT INTO arp_nutzungsplanung_transfer_pub_v1.nutzungsplanung_empfindlichkeitsstufe
SELECT
    empfindlichkeitsstufe.t_id,
    empfindlichkeitsstufe.t_ili_tid,
    empfindlichkeitsstufe.geometrie,
    empfindlichkeitsstufe.geschaefts_nummer,
    empfindlichkeitsstufe.rechtsstatus,
    empfindlichkeitsstufe.publiziertab,
    empfindlichkeitsstufe.bemerkungen,
    empfindlichkeitsstufe.erfasser,
    empfindlichkeitsstufe.datum_erfassung,
    empfindlichkeitsstufe.publiziertbis,
    empfindlichkeitsstufe.typ_bezeichnung,
    empfindlichkeitsstufe.typ_abkuerzung,
    empfindlichkeitsstufe.typ_verbindlichkeit,
    empfindlichkeitsstufe.typ_bemerkungen,
    empfindlichkeitsstufe.typ_kt,
    ${bfsnr_param} AS bfs_nr,
    typ_empfindlichkeitsstufe_json_dokument_agg.dokumente::json AS dokumente,
    substring(empfindlichkeitsstufe.typ_kt,2,3)::int4 AS typ_code_kt,
    substring(empfindlichkeitsstufe.typ_kt,2,2)::int4  AS typ_code_ch
FROM
    empfindlichkeitsstufe
    LEFT JOIN typ_empfindlichkeitsstufe_json_dokument_agg
    ON empfindlichkeitsstufe.typ_t_id= typ_empfindlichkeitsstufe_json_dokument_agg.typ_empfindlichkeitsstufe_t_id
;