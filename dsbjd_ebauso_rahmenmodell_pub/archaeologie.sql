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
    amultipolygon AS geometrie,
    fundstellen_nummer AS artcode,
    fundstellen_art AS beschreibung,
    'ch.SO.archaeologie' AS thema,
    NULL::TEXT AS rechtsstatus,
    NULL::TEXT AS rechtsstatus_txt
FROM 
    ada_archaeologie_pub_v1.public_flaechenfundstelle_siedlungsgebiet 
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
    ST_Multi(punkt) AS geometrie,
    fundstellen_nummer AS artcode,
    fundstellen_art AS beschreibung,
    'ch.SO.archaeologie' AS thema,
    NULL::TEXT AS rechtsstatus,
    NULL::TEXT AS rechtsstatus_txt
FROM 
    ada_archaeologie_pub_v1.public_punktfundstelle_siedlungsgebiet  
;