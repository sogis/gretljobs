UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_militaerischer_schiessplatz AS schiessplatz
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	schiessplatz.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_militaerischer_schiessplatz AS schiessplatz
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	schiessplatz.begruendung_aus_vsb_entlassen = begruendung.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_militaerischer_schiessplatz AS schiessplatz
SET
	betriebsstatus_txt =  betriebsstatus.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_militaerischer_schiessplatz_betriebsstatus AS betriebsstatus
WHERE 
	schiessplatz.betriebsstatus = betriebsstatus.ilicode
;