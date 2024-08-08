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
    ST_Multi(geometrie) AS geometrie,
    bezeichnung AS artcode, 
    NULL::TEXT AS beschreibung,
    'ch.SO.fruchtfolgeflaechen',
    NULL::TEXT AS rechtsstatus,
    NULL::TEXT AS rechtsstatus_txt
FROM 
    alw_fruchtfolgeflaechen_pub_v1.fruchtfolgeflaeche
;