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
    mpoly AS geometrie,
    schutzstufe_code AS artcode,
    objektname AS beschreibung,
    'ch.SO.Denkmalschutz' AS thema,
    NULL::TEXT AS rechtsstatus,
    NULL::TEXT AS rechtsstatus_txt
FROM 
    ada_denkmalschutz_pub.denkmal_polygon 
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
    mpunkt AS geometrie,
    schutzstufe_code AS artcode,
    objektname AS beschreibung,
    'ch.SO.Denkmalschutz' AS thema,
    NULL::TEXT AS rechtsstatus,
    NULL::TEXT AS rechtsstatus_txt
FROM 
    ada_denkmalschutz_pub.denkmal_punkt 
;