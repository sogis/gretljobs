DELETE FROM afu_gewaesserschutz_zonen_areale_mgdm_v1.gwszonen_gwsareal
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
    t_id,
    identifikator, 
    geometrie, 
    bemerkungen, 
    bemerkungen_lang, 
    typ, 
    istaltrechtlich, 
    astatus
FROM afu_gewaesserschutz_zonen_areale_v1.gwszonen_gwsareal;
