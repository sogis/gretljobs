UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlbruecke AS stahlbruecke
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	stahlbruecke.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlbruecke AS stahlbruecke
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	stahlbruecke.begruendung_aus_vsb_entlassen = begruendung.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlbruecke AS stahlbruecke
SET
	brueckentyp_txt =  brueckentyp.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_stahlbruecke_brueckentyp AS brueckentyp
WHERE 
	stahlbruecke.brueckentyp = brueckentyp.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlbruecke AS stahlbruecke
SET
	betriebsstatus_txt =  betriebsstatus.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.betriebsstatus AS betriebsstatus
WHERE 
	stahlbruecke.betriebsstatus = betriebsstatus.ilicode
;