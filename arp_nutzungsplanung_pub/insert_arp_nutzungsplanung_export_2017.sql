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
    t_id,
    typ_grundnutzung,
    dokument
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_grundnutzung_dokument
WHERE
   t_datasetname::int4 = ${bfsnr_param}
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
    t_id,
    typ_ueberlagernd_flaeche,
    dokument
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_flaeche_dokument
WHERE
   t_datasetname::int4 = ${bfsnr_param}
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
    t_id,
    typ_ueberlagernd_linie,
    dokument
FROM
   arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_linie_dokument
WHERE
    t_datasetname::int4 = ${bfsnr_param}
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
    t_id,
    typ_ueberlagernd_punkt,
    dokument
FROM
    arp_nutzungsplanung_v1.nutzungsplanung_typ_ueberlagernd_punkt_dokument
WHERE
    t_datasetname::int4 = ${bfsnr_param}
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
    t_id,
    typ_erschliessung_flaechenobjekt,
    dokument
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt_dokument
WHERE
    t_datasetname::int4 = ${bfsnr_param}
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
    t_id,
    typ_erschliessung_linienobjekt,
    dokument
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument
WHERE
    t_datasetname::int4 = ${bfsnr_param}
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
    t_id,
    typ_erschliessung_punktobjekt,
    dokument
FROM
    arp_nutzungsplanung_v1.erschlssngsplnung_typ_erschliessung_punktobjekt_dokument
WHERE
    t_datasetname::int4 = ${bfsnr_param}
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
    t_id,
    typ_empfindlichkeitsstufen AS typ_ueberlagernd_flaeche ,
    dokument
FROM
    arp_nutzungsplanung_v1.laermmpfhktsstfen_typ_empfindlichkeitsstufe_dokument
WHERE
    t_datasetname::int4 = ${bfsnr_param}
;