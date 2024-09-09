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
    objekttyp AS artcoce,
    objekttyp AS beschreibung,
    'ch.SO.RichtplanJuraschutzzone' AS thema,
    NULL::TEXT AS rechtsstatus,
    NULL::TEXT AS rechtsstatus_txt        
FROM    
    arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche 
WHERE 
    objekttyp = 'Juraschutzzone'
;