DELETE FROM 
    dsbjd_ebauso_rahmenmodell_pub_v1.fachthemen_fachthema_polygon
;

DELETE FROM 
    dsbjd_ebauso_rahmenmodell_pub_v1.fachthemen_fachthema_linie
;

DELETE FROM 
    dsbjd_ebauso_rahmenmodell_pub_v1.fachthemen_fachthema_punkt
;

INSERT INTO 
    dsbjd_ebauso_rahmenmodell_pub_v1.fachthemen_fachthema_polygon
    (
        geometrie,
        artcode,
        beschreibung,
        thema,
        rechtsstatus,
        rechtsstatus_txt
    )    
SELECT 
    geometrie,
    artcode,
    beschreibung,
    thema,
    rechtsstatus,
    rechtsstatus_txt 
FROM 
    dsbjd_ebauso_rahmenmodell_stage_v1.fachthemen_fachthema_polygon 
;

INSERT INTO 
    dsbjd_ebauso_rahmenmodell_pub_v1.fachthemen_fachthema_linie
    (
        geometrie,
        artcode,
        beschreibung,
        thema,
        rechtsstatus,
        rechtsstatus_txt
    )    
SELECT 
    geometrie,
    artcode,
    beschreibung,
    thema,
    rechtsstatus,
    rechtsstatus_txt 
FROM 
    dsbjd_ebauso_rahmenmodell_stage_v1.fachthemen_fachthema_linie
;

INSERT INTO 
    dsbjd_ebauso_rahmenmodell_pub_v1.fachthemen_fachthema_punkt
    (
        geometrie,
        artcode,
        beschreibung,
        thema,
        rechtsstatus,
        rechtsstatus_txt
    )    
SELECT 
    geometrie,
    artcode,
    beschreibung,
    thema,
    rechtsstatus,
    rechtsstatus_txt 
FROM 
    dsbjd_ebauso_rahmenmodell_stage_v1.fachthemen_fachthema_punkt
;