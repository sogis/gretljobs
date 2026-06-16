UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlmast AS stahlmast
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	stahlmast.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlmast AS stahlmast
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	stahlmast.begruendung_aus_vsb_entlassen = begruendung.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlmast AS stahlmast
SET
	betriebsstatus_txt =  betriebsstatus.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.betriebsstatus AS betriebsstatus
WHERE 
	stahlmast.betriebsstatus = betriebsstatus.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlmast AS stahlmast
SET
	radius_txt =  radius.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_stahlmast_radius AS radius
WHERE 
	stahlmast.radius = radius.ilicode
;