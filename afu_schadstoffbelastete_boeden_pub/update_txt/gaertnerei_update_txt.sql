UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_gaertnerei AS gaertnerei
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	gaertnerei.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_gaertnerei AS gaertnerei
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	gaertnerei.begruendung_aus_vsb_entlassen = begruendung.ilicode
;