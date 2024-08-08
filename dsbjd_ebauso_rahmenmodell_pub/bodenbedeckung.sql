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
    art_txt AS artcode,
    art_txt AS beschreibung,
    'ch.SO.bodenbedeckung' AS thema,
    NULL::TEXT AS rechtsstatus,
    NULL::TEXT AS rechtsstatus_txt    
FROM    
    agi_mopublic_pub.mopublic_bodenbedeckung 
WHERE 
    art_txt ILIKE '%Wald%' OR art_txt ILIKE '%Gewaesser%'
;