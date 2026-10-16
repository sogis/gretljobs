-- Datenumbau von Modell Modell SO_Nutzungsplanung_Nachfuehrung_20201005 ins SO_Nutzungsplanung_20171118
-- Für Datenexport für Ing.-Büro
-- dataset BFS-Nr.
INSERT INTO arp_nutzungsplanung_export_v1.t_ili2db_dataset
SELECT
    t_id,
    datasetname
FROM
    arp_nutzungsplanung_v1.t_ili2db_dataset
WHERE
   datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.t_ili2db_basket
SELECT
    basket.t_id,
    basket.dataset,
    replace (basket.topic,'SO_ARP_Nutzungsplanung_Nachfuehrung_20201005', 'SO_Nutzungsplanung_20171118')AS topic,
    basket.t_ili_tid,
    basket.attachmentkey,
    basket.domains
FROM
    arp_nutzungsplanung_v1.t_ili2db_basket AS basket
    LEFT JOIN arp_nutzungsplanung_v1.t_ili2db_dataset AS dataset
    ON basket.dataset=dataset.t_id
WHERE
    topic != 'SO_ARP_Nutzungsplanung_Nachfuehrung_20201005.Laermempfindlichkeitsstufen'
    AND
    dataset.datasetname::int4 = ${bfsnr_param}
;

--Dokumente
INSERT INTO arp_nutzungsplanung_export_v1.rechtsvorschrften_dokument
SELECT
    t_id,
    t_ili_tid,
    dokumentid,
    titel,
    offiziellertitel,
    abkuerzung,
    offiziellenr,
    kanton,
    gemeinde,
    publiziertab,
    CASE rechtsstatus
        WHEN 'AenderungMitVorwirkung'
            THEN 'laufendeAenderung'
        WHEN 'AenderungOhneVorwirkung'
            THEN 'laufendeAenderung'
        ELSE 'inKraft'
    END AS rechtsstatus,
    textimweb,
    bemerkungen,
    rechtsvorschrift
FROM
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument
WHERE
    t_datasetname::int4 = ${bfsnr_param}
    AND
    rechtsstatus = 'inKraft' -- nur die inKraft sind, weil es aufgehobene Pläne gibt ohne Datum und bei Modell 2017 ist das Attribut "publiziertab" MANDATORY!
;

-- Grundnutzung
INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_grundnutzung
SELECT
    t_id,
    t_ili_tid,
    typ_kt,
    code_kommunal,
    nutzungsziffer,
    nutzungsziffer_art,
    geschosszahl,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    bemerkungen
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_grundnutzung
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_grundnutzung
SELECT
    t_id,
    t_ili_tid,
    geometrie,
    geschaefts_nummer AS name_nummer,
    CASE rechtsstatus
        WHEN 'AenderungMitVorwirkung'
            THEN 'laufendeAenderung'
        WHEN 'AenderungOhneVorwirkung'
            THEN 'laufendeAenderung'
        ELSE 'inKraft'
    END AS rechtsstatus,
    CASE
        WHEN publiziertab IS NULL
            THEN datum
        ELSE publiziertab
    END AS publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_grundnutzung
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_grundnutzung
WHERE
    t_datasetname::int4 = ${bfsnr_param}
    AND 
    rechtsstatus = 'inKraft'
;

--Beziehung Dokument Grundnutzung
INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_grundnutzung_dokument
SELECT
    typ_dok.t_id,
    typ_dok.typ_grundnutzung,
    typ_dok.dokument
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_grundnutzung_dokument AS typ_dok
    LEFT JOIN 
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dok ON typ_dok.dokument = dok.t_id
WHERE
   typ_dok.t_datasetname::int4 = ${bfsnr_param} AND dok.rechtsstatus = 'inKraft' -- nur die inKraft sind, weil es aufgehobene Pläne gibt ohne Datum und bei Modell 2017 ist das Attribut "publiziertab" MANDATORY!
   
;

--überlagernde Fläche
INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_ueberlagernd_flaeche
SELECT
    t_id,
    t_ili_tid,
    typ_kt,
    code_kommunal,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    bemerkungen
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_flaeche
WHERE
   t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_ueberlagernd_flaeche
SELECT
    t_id,
    t_ili_tid,
    geometrie,
    geschaefts_nummer AS name_nummer,
    CASE rechtsstatus
        WHEN 'AenderungMitVorwirkung'
            THEN 'laufendeAenderung'
        WHEN 'AenderungOhneVorwirkung'
            THEN 'laufendeAenderung'
        ELSE 'inKraft'
    END AS rechtsstatus,
    CASE
        WHEN publiziertab IS NULL
            THEN datum
        ELSE publiziertab
    END AS publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_ueberlagernd_flaeche
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_ueberlagernd_flaeche
WHERE
   t_datasetname::int4 = ${bfsnr_param}
;

--Beziehung Dokument überlagernde Fläche
INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_ueberlagernd_flaeche_dokument
SELECT
    typ_dok.t_id,
    typ_dok.typ_ueberlagernd_flaeche,
    typ_dok.dokument
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_flaeche_dokument AS typ_dok
    LEFT JOIN 
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dok ON typ_dok.dokument = dok.t_id
WHERE
   typ_dok.t_datasetname::int4 = ${bfsnr_param} AND dok.rechtsstatus = 'inKraft' -- nur die inKraft sind, weil es aufgehobene Pläne gibt ohne Datum und bei Modell 2017 ist das Attribut "publiziertab" MANDATORY!
;

--überlagernde Linie
INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_ueberlagernd_linie
SELECT
    t_id,
    t_ili_tid,
    typ_kt,
    code_kommunal,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    bemerkungen
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_linie
WHERE
   t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_ueberlagernd_linie
SELECT
    t_id,
    t_ili_tid,
    geometrie,
    geschaefts_nummer AS name_nummer,
    CASE rechtsstatus
        WHEN 'AenderungMitVorwirkung'
            THEN 'laufendeAenderung'
        WHEN 'AenderungOhneVorwirkung'
            THEN 'laufendeAenderung'
        ELSE 'inKraft'
    END AS rechtsstatus,
     CASE
        WHEN publiziertab IS NULL
            THEN datum
        ELSE publiziertab
    END AS publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_ueberlagernd_linie
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_ueberlagernd_linie
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

--Beziehung Dokument überlagernde Linie
INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_ueberlagernd_linie_dokument
SELECT
    typ_dok.t_id,
    typ_dok.typ_ueberlagernd_linie,
    typ_dok.dokument
FROM
   arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_linie_dokument AS typ_dok
    LEFT JOIN 
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dok ON typ_dok.dokument = dok.t_id
WHERE
   typ_dok.t_datasetname::int4 = ${bfsnr_param} AND dok.rechtsstatus = 'inKraft' -- nur die inKraft sind, weil es aufgehobene Pläne gibt ohne Datum und bei Modell 2017 ist das Attribut "publiziertab" MANDATORY!
;

--überlagernde Punkt
INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_ueberlagernd_punkt
SELECT
    t_id,
    t_ili_tid,
    typ_kt,
    code_kommunal,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    bemerkungen
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_punkt
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_ueberlagernd_punkt
SELECT
    t_id,
    t_ili_tid,
    geometrie,
    geschaefts_nummer AS name_nummer,
    CASE rechtsstatus
        WHEN 'AenderungMitVorwirkung'
            THEN 'laufendeAenderung'
        WHEN 'AenderungOhneVorwirkung'
            THEN 'laufendeAenderung'
        ELSE 'inKraft'
    END AS rechtsstatus,
    CASE
        WHEN publiziertab IS NULL
            THEN datum
        ELSE publiziertab
    END AS publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_ueberlagernd_punkt
FROM
   arp_nutzungsplanung_v1.nutzungsplanung_ueberlagernd_punkt
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

--Beziehung Dokument überlagernde Punkt
INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_ueberlagernd_punkt_dokument
SELECT
    typ_dok.t_id,
    typ_dok.typ_ueberlagernd_punkt,
    typ_dok.dokument
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_punkt_dokument AS typ_dok
    LEFT JOIN 
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dok ON typ_dok.dokument = dok.t_id
WHERE
   typ_dok.t_datasetname::int4 = ${bfsnr_param} AND dok.rechtsstatus = 'inKraft' -- nur die inKraft sind, weil es aufgehobene Pläne gibt ohne Datum und bei Modell 2017 ist das Attribut "publiziertab" MANDATORY!
;

-- Erschliessung Fläche
INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt
SELECT
    t_id,
    t_ili_tid,
    typ_kt,
    code_kommunal,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    bemerkungen
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_erschliessung_flaechenobjekt

SELECT
    t_id,
    t_ili_tid,
    geometrie,
    geschaefts_nummer AS name_nummer,
    CASE rechtsstatus
        WHEN 'AenderungMitVorwirkung'
            THEN 'laufendeAenderung'
        WHEN 'AenderungOhneVorwirkung'
            THEN 'laufendeAenderung'
        ELSE 'inKraft'
    END AS rechtsstatus,
    CASE
        WHEN publiziertab IS NULL
            THEN datum
        ELSE publiziertab
    END AS publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_erschliessung_flaechenobjekt
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_erschliessung_flaechenobjekt
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt_dokument
SELECT
    typ_dok.t_id,
    typ_dok.typ_erschliessung_flaechenobjekt,
    typ_dok.dokument
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt_dokument AS typ_dok
    LEFT JOIN 
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dok ON typ_dok.dokument = dok.t_id
WHERE
   typ_dok.t_datasetname::int4 = ${bfsnr_param} AND dok.rechtsstatus = 'inKraft' -- nur die inKraft sind, weil es aufgehobene Pläne gibt ohne Datum und bei Modell 2017 ist das Attribut "publiziertab" MANDATORY!
;

-- Erschliessung Linie
INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_typ_erschliessung_linienobjekt
SELECT
    t_id,
    t_ili_tid,
    typ_kt,
    code_kommunal,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    bemerkungen
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_linienobjekt
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_erschliessung_linienobjekt
SELECT
    t_id,
    t_ili_tid,
    geometrie,
    geschaefts_nummer AS name_nummer,
    CASE rechtsstatus
        WHEN 'AenderungMitVorwirkung'
            THEN 'laufendeAenderung'
        WHEN 'AenderungOhneVorwirkung'
            THEN 'laufendeAenderung'
        ELSE 'inKraft'
    END AS rechtsstatus,
    CASE
        WHEN publiziertab IS NULL
            THEN datum
        ELSE publiziertab
    END AS publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_erschliessung_linienobjekt
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_erschliessung_linienobjekt
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument
SELECT
    typ_dok.t_id,
    typ_dok.typ_erschliessung_linienobjekt,
    typ_dok.dokument
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument AS typ_dok
    LEFT JOIN 
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dok ON typ_dok.dokument = dok.t_id
WHERE
   typ_dok.t_datasetname::int4 = ${bfsnr_param} AND dok.rechtsstatus = 'inKraft' -- nur die inKraft sind, weil es aufgehobene Pläne gibt ohne Datum und bei Modell 2017 ist das Attribut "publiziertab" MANDATORY!
;

-- Erschliessung Punkt
INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_typ_erschliessung_punktobjekt
SELECT
    t_id,
    t_ili_tid,
    typ_kt,
    code_kommunal,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    bemerkungen
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_punktobjekt
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_erschliessung_punktobjekt
SELECT
    t_id,
    t_ili_tid,
    geometrie,
    geschaefts_nummer AS name_nummer,
    CASE rechtsstatus
        WHEN 'AenderungMitVorwirkung'
            THEN 'laufendeAenderung'
        WHEN 'AenderungOhneVorwirkung'
             THEN 'laufendeAenderung'
        ELSE 'inKraft'
    END AS rechtsstatus,
    CASE
        WHEN publiziertab IS NULL
            THEN datum
        ELSE publiziertab
    END AS publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_erschliessung_punktobjekt
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_erschliessung_punktobjekt
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_typ_erschliessung_punktobjekt_dokument
SELECT
    typ_dok.t_id,
    typ_dok.typ_erschliessung_punktobjekt,
    typ_dok.dokument
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_punktobjekt_dokument AS typ_dok
    LEFT JOIN 
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dok ON typ_dok.dokument = dok.t_id
WHERE
   typ_dok.t_datasetname::int4 = ${bfsnr_param} AND dok.rechtsstatus = 'inKraft' -- nur die inKraft sind, weil es aufgehobene Pläne gibt ohne Datum und bei Modell 2017 ist das Attribut "publiziertab" MANDATORY!
;

-- Lärmempfindlichkeitsstufen
INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_ueberlagernd_flaeche
SELECT
    t_id,
    t_ili_tid,
    typ_kt,
    substr( "typ_kt" ,2,3)  || '0' AS code_kommunal,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    bemerkungen
FROM
    arp_nutzungsplanung_v1.laermmpfhktsstfen_typ_empfindlichkeitsstufe
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_ueberlagernd_flaeche
SELECT
    t_id,
    t_ili_tid,
    geometrie,
    geschaefts_nummer AS name_nummer,
    CASE rechtsstatus
        WHEN 'AenderungMitVorwirkung'
            THEN 'laufendeAenderung'
        WHEN 'AenderungOhneVorwirkung'
            THEN 'laufendeAenderung'
        ELSE 'inKraft'
   END AS rechtsstatus,
    CASE
        WHEN publiziertab IS NULL
            THEN datum
        ELSE publiziertab
    END AS publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_empfindlichkeitsstufen AS typ_ueberlagernd_flaeche
FROM
    arp_nutzungsplanung_v1.laermmpfhktsstfen_empfindlichkeitsstufe
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;

INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_ueberlagernd_flaeche_dokument
SELECT
    typ_dok.t_id,
    typ_dok.typ_empfindlichkeitsstufen AS typ_ueberlagernd_flaeche ,
    typ_dok.dokument
FROM
    arp_nutzungsplanung_v1.laermmpfhktsstfen_typ_empfindlichkeitsstufe_dokument AS typ_dok
    LEFT JOIN 
    arp_nutzungsplanung_v1.rechtsvorschrften_dokument AS dok ON typ_dok.dokument = dok.t_id
WHERE
   typ_dok.t_datasetname::int4 = ${bfsnr_param} AND dok.rechtsstatus = 'inKraft' -- nur die inKraft sind, weil es aufgehobene Pläne gibt ohne Datum und bei Modell 2017 ist das Attribut "publiziertab" MANDATORY!
;