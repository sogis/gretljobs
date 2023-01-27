-- Datenumbau von Modell Modell SO_Nutzungsplanung_Nachfuehrung_20201005 ins SO_Nutzungsplanung_20171118
-- Für Datenexport für Ing.-Büro
-- dataset Kanton
INSERT INTO arp_nutzungsplanung_export_v1.t_ili2db_dataset
SELECT
    nextval('arp_nutzungsplanung_export_v1.t_ili2db_seq'::regclass) AS t_id,
    'Kanton' AS datasetname
;

INSERT INTO arp_nutzungsplanung_export_v1.t_ili2db_basket
SELECT
    nextval('arp_nutzungsplanung_export_v1.t_ili2db_seq'::regclass) AS t_id,
    (SELECT
        t_id
    FROM
        arp_nutzungsplanung_export_v1.t_ili2db_dataset
    WHERE
        datasetname = 'Kanton') AS dataset,
    'SO_Nutzungsplanung_20171118.Nutzungsplanung' AS topic,
    NULL AS  t_ili_tid,
    'Nachfuehrung_Kanton' AS attachmentkey,
    NULL AS domains
;

INSERT INTO arp_nutzungsplanung_export_v1.t_ili2db_basket
SELECT
    nextval('arp_nutzungsplanung_export_v1.t_ili2db_seq'::regclass) AS t_id,
    (SELECT
        t_id
    FROM
        arp_nutzungsplanung_export_v1.t_ili2db_dataset
    WHERE
        datasetname = 'Kanton') AS dataset,
    'SO_Nutzungsplanung_20171118.Rechtsvorschriften' AS topic,
    NULL AS  t_ili_tid,
    'Nachfuehrung_Kanton' AS attachmentkey,
    NULL AS domains
;

INSERT INTO arp_nutzungsplanung_export_v1.t_ili2db_basket
SELECT
    nextval('arp_nutzungsplanung_export_v1.t_ili2db_seq'::regclass) AS t_id,
    (SELECT
        t_id
    FROM
        arp_nutzungsplanung_export_v1.t_ili2db_dataset
    WHERE
        datasetname = 'Kanton') AS dataset,
    'SO_Nutzungsplanung_20171118.Erschliessungsplanung' AS topic,
    NULL AS  t_ili_tid,
    'Nachfuehrung_Kanton' AS attachmentkey,
    NULL AS domains
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
    arp_nutzungsplanung_kanton_v1.rechtsvorschrften_dokument
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
    arp_nutzungsplanung_kanton_v1.nutzungsplanung_typ_ueberlagernd_flaeche
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
    publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_ueberlagernd_flaeche
FROM
    arp_nutzungsplanung_kanton_v1.nutzungsplanung_ueberlagernd_flaeche
;

--Beziehung Dokument überlagernde Fläche
INSERT INTO arp_nutzungsplanung_export_v1.nutzungsplanung_typ_ueberlagernd_flaeche_dokument
SELECT
    t_id,
    typ_ueberlagernd_flaeche,
    dokument
FROM
    arp_nutzungsplanung_kanton_v1.nutzungsplanung_typ_ueberlagernd_flaeche_dokument
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
    arp_nutzungsplanung_kanton_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt
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
    publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_erschliessung_flaechenobjekt
FROM
    arp_nutzungsplanung_kanton_v1.erschlssngsplnung_erschliessung_flaechenobjekt
;

INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt_dokument
SELECT
    t_id,
    typ_erschliessung_flaechenobjekt,
    dokument
FROM
    arp_nutzungsplanung_kanton_v1.erschlssngsplnung_typ_erschliessung_flaechenobjekt_dokument
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
    arp_nutzungsplanung_kanton_v1.erschlssngsplnung_typ_erschliessung_linienobjekt
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
    publiziertab,
    bemerkungen,
    erfasser,
    datum,
    typ_erschliessung_linienobjekt
FROM
    arp_nutzungsplanung_kanton_v1.erschlssngsplnung_erschliessung_linienobjekt
;

INSERT INTO arp_nutzungsplanung_export_v1.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument
SELECT
    t_id,
    typ_erschliessung_linienobjekt,
    dokument
FROM
    arp_nutzungsplanung_kanton_v1.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument
;