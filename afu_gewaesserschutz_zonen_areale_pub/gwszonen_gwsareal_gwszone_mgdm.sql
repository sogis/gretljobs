INSERT INTO afu_gewaesserschutz_zonen_areale_mgdm_v1.gwszonen_gwszone  (
    t_id,
    identifikator, 
    geometrie, 
    bemerkungen, 
    bemerkungen_lang, 
    typ, 
    kantonaletypbezeichnung, 
    kantonaletypbezeichnung_lang, 
    istaltrechtlich, 
    astatus
)

SELECT 
    gzone.t_id,
    gzone.identifikator, 
    gzone.geometrie, 
    gzone.bemerkungen, 
    gzone.bemerkungen_lang, 
    gzone.typ, 
    gzone.kantonaletypbezeichnung, 
    gzone.kantonaletypbezeichnung_lang, 
    gzone.istaltrechtlich, 
    gzone.astatus
FROM 
    afu_gewaesserschutz_zonen_areale_v1.gwszonen_gwszone AS gzone
        LEFT JOIN afu_gewaesserschutz_zonen_areale_mgdm_v1.gwszonen_status AS status ON status.t_id = gzone.astatus
WHERE 
    status.kantonalerstatus IS NULL 
        OR status.kantonalerstatus  = 'RichtplanFestsetzung'
    
    
;

INSERT INTO afu_gewaesserschutz_zonen_areale_mgdm_v1.gwszonen_gwsareal  (
    t_id,
    identifikator, 
    geometrie, 
    bemerkungen, 
    bemerkungen_lang, 
    typ, 
    istaltrechtlich, 
    astatus
)

SELECT 
    areal.t_id,
    areal.identifikator, 
    areal.geometrie, 
    areal.bemerkungen, 
    areal.bemerkungen_lang, 
    areal.typ, 
    areal.istaltrechtlich, 
    areal.astatus
FROM 
    afu_gewaesserschutz_zonen_areale_v1.gwszonen_gwsareal AS areal
        LEFT JOIN afu_gewaesserschutz_zonen_areale_mgdm_v1.gwszonen_status AS status ON status.t_id = areal.astatus
WHERE 
    status.kantonalerstatus IS NULL 
        OR status.kantonalerstatus  = 'RichtplanFestsetzung'
;
