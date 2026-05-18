INSERT INTO afu_gewaesserschutz_zonen_areale_mgdm_v1.multilingualuri (
            t_id ,
            t_seq,
            gwszonen_dokument_textimweb,
            transfermetadaten_amt_amtimweb,
            transfrmtdtstllngsdnst_verweiswms     
)
SELECT
    nextval('afu_gewaesserschutz_zonen_areale_mgdm_v1.t_ili2db_seq'::regclass) AS t_id,
    0 AS t_seq,
    dokumente_dokument.t_id AS gwszonen_dokument_textimweb,
    0 AS transfermetadaten_amt_amtimweb,
    0 AS transfrmtdtstllngsdnst_verweiswms
FROM afu_gewaesserschutz_zonen_areale_v1.gwszonen_dokument AS dokumente_dokument
;

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
FROM afu_gewaesserschutz_zonen_areale_v1.gwszonen_gwszone
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
FROM afu_gewaesserschutz_zonen_areale_v1.gwszonen_gwsareal
;
