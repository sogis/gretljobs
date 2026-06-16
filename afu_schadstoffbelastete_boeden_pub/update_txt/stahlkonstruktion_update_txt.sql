UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlkonstruktion AS stahlkonstruktion
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	stahlkonstruktion.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlkonstruktion AS stahlkonstruktion
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	stahlkonstruktion.begruendung_aus_vsb_entlassen = begruendung.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlkonstruktion AS stahlkonstruktion
SET
	betriebsstatus_txt =  betriebsstatus.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.betriebsstatus AS betriebsstatus
WHERE 
	stahlkonstruktion.betriebsstatus = betriebsstatus.ilicode
;