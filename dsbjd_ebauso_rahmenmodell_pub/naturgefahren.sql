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
    geometrie,
    gefahrenstufe_txt AS artcode,
    charakterisierung AS beschreibung,
    'ch.SO.GefahrengebietSynoptisch' AS thema,
    NULL::TEXT AS rechtsstatus,
    NULL::TEXT AS rechtsstatus_txt
FROM 
    afu_naturgefahren_pub_v1.synoptisches_gefahrengebiet
;