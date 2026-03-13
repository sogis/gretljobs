DELETE FROM afu_gewaesserschutz_zonen_areale_mgdm_v1.gwszonen_gwszone
;

INSERT INTO afu_gewaesserschutz_zonen_areale_mgdm_v1.gwszonen_gwszone  (
    t_id
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
    t_id
    identifikator, 
    geometrie, 
    bemerkungen, 
    bemerkungen_lang, 
    typ, 
    kantonaletypbezeichnung, 
    kantonaletypbezeichnung_lang, 
    istaltrechtlich, 
    astatus
FROM afu_gewaesserschutz_zonen_areale_v1.gwszonen_gwszone;
