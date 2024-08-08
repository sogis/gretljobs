INSERT INTO 
    dsbjd_ebauso_rahmenmodell_stage_v1.fachthemen_fachthema_polygon
    (
        geometrie,
        artcode,
        beschreibung,
        thema,
        rechtsstatus,
        rechtsstatus_txt
    )    
SELECT 
    ST_Multi(geometrie),
    typ_kt AS artcode,
    typ_bezeichnung AS beschreibung,
    'ch.SO.NutzungsplanungGrundnutzung' AS thema,
    rechtsstatus,
    CASE 
        WHEN rechtsstatus = 'inKraft' THEN 'in Kraft'
        WHEN rechtsstatus = 'AenderungMitVorwirkung' THEN 'Änderung mit Vorwirkung'
        WHEN rechtsstatus = 'AenderungOhneVorwirkung' THEN 'Änderung ohne Vorwirkung'
    END AS rechtsstatus_txt

FROM 
    arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
;

INSERT INTO 
    dsbjd_ebauso_rahmenmodell_stage_v1.fachthemen_fachthema_polygon
    (
        geometrie,
        artcode,
        beschreibung,
        thema,
        rechtsstatus,
        rechtsstatus_txt
    )    
SELECT 
    ST_Multi(geometrie),
    typ_kt AS artcode,
    typ_bezeichnung AS beschreibung,
    'ch.SO.NutzungsplanungUeberlagernd' AS thema,
    rechtsstatus,
    CASE 
        WHEN rechtsstatus = 'inKraft' THEN 'in Kraft'
        WHEN rechtsstatus = 'AenderungMitVorwirkung' THEN 'Änderung mit Vorwirkung'
        WHEN rechtsstatus = 'AenderungOhneVorwirkung' THEN 'Änderung ohne Vorwirkung'
    END AS rechtsstatus_txt

FROM 
    arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche 
;

INSERT INTO 
    dsbjd_ebauso_rahmenmodell_stage_v1.fachthemen_fachthema_linie
    (
        geometrie,
        artcode,
        beschreibung,
        thema,
        rechtsstatus,
        rechtsstatus_txt
    )
SELECT 
    ST_Multi(geometrie),
    typ_kt AS artcode,
    typ_bezeichnung AS beschreibung,
    'ch.SO.NutzungsplanungUeberlagernd' AS thema,
    rechtsstatus,
    CASE 
        WHEN rechtsstatus = 'inKraft' THEN 'in Kraft'
        WHEN rechtsstatus = 'AenderungMitVorwirkung' THEN 'Änderung mit Vorwirkung'
        WHEN rechtsstatus = 'AenderungOhneVorwirkung' THEN 'Änderung ohne Vorwirkung'
    END AS rechtsstatus_txt

FROM 
    arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_linie 
;

INSERT INTO 
    dsbjd_ebauso_rahmenmodell_stage_v1.fachthemen_fachthema_punkt
    (
        geometrie,
        artcode,
        beschreibung,
        thema,
        rechtsstatus,
        rechtsstatus_txt
    )
SELECT 
    ST_Multi(geometrie),
    typ_kt AS artcode,
    typ_bezeichnung AS beschreibung,
    'ch.SO.NutzungsplanungUeberlagernd' AS thema,
    rechtsstatus,
    CASE 
        WHEN rechtsstatus = 'inKraft' THEN 'in Kraft'
        WHEN rechtsstatus = 'AenderungMitVorwirkung' THEN 'Änderung mit Vorwirkung'
        WHEN rechtsstatus = 'AenderungOhneVorwirkung' THEN 'Änderung ohne Vorwirkung'
    END AS rechtsstatus_txt

FROM 
    arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_punkt
;

INSERT INTO 
    dsbjd_ebauso_rahmenmodell_stage_v1.fachthemen_fachthema_linie
    (
        geometrie,
        artcode,
        beschreibung,
        thema,
        rechtsstatus,
        rechtsstatus_txt
    )    
SELECT 
    ST_Multi(geometrie),
    typ_kt AS artcode,
    typ_bezeichnung AS beschreibung,
    'ch.SO.NutzungsplanungErschliessung' AS thema,
    rechtsstatus,
    CASE 
        WHEN rechtsstatus = 'inKraft' THEN 'in Kraft'
        WHEN rechtsstatus = 'AenderungMitVorwirkung' THEN 'Änderung mit Vorwirkung'
        WHEN rechtsstatus = 'AenderungOhneVorwirkung' THEN 'Änderung ohne Vorwirkung'
    END AS rechtsstatus_txt
FROM 
    arp_nutzungsplanung_pub_v1.nutzungsplanung_erschliessung_linienobjekt 
;

INSERT INTO 
    dsbjd_ebauso_rahmenmodell_stage_v1.fachthemen_fachthema_punkt
    (
        geometrie,
        artcode,
        beschreibung,
        thema,
        rechtsstatus,
        rechtsstatus_txt
    )    
SELECT 
    ST_Multi(geometrie),
    typ_kt AS artcode,
    typ_bezeichnung AS beschreibung,
    'ch.SO.NutzungsplanungErschliessung' AS thema,
    rechtsstatus,
    CASE 
        WHEN rechtsstatus = 'inKraft' THEN 'in Kraft'
        WHEN rechtsstatus = 'AenderungMitVorwirkung' THEN 'Änderung mit Vorwirkung'
        WHEN rechtsstatus = 'AenderungOhneVorwirkung' THEN 'Änderung ohne Vorwirkung'
    END AS rechtsstatus_txt
FROM 
    arp_nutzungsplanung_pub_v1.nutzungsplanung_erschliessung_punktobjekt   
;
