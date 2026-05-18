DELETE FROM afu_gewaesserschutz_zonen_areale_mgdm_v1.gwszonen_status
;

INSERT INTO afu_gewaesserschutz_zonen_areale_mgdm_v1.gwszonen_status  (
    t_id,
    rechtsstatus, 
    rechtskraftdatum, 
    bemerkungen, 
    bemerkungen_lang, 
    kantonalerstatus, 
    kantonalerstatus_lang
)

SELECT 
    t_id,
    rechtsstatus, 
    rechtskraftdatum, 
    bemerkungen, 
    bemerkungen_lang, 
    kantonalerstatus, 
    kantonalerstatus_lang
FROM afu_gewaesserschutz_zonen_areale_v1.gwszonen_status;
