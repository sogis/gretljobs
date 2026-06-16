UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_schiessanlage AS schiessanlage
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	schiessanlage.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_schiessanlage AS schiessanlage
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	schiessanlage.begruendung_aus_vsb_entlassen = begruendung.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_schiessanlage AS schiessanlage
SET
	trennkriterium_txt =  trennkriterium.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_schiessanlage_trennkriterium AS trennkriterium
WHERE 
	schiessanlage.trennkriterium = trennkriterium.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_schiessanlage AS schiessanlage
SET
	sanierungsstatus_txt =  sanierungsstatus.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_schiessanlage_sanierungsstatus AS sanierungsstatus
WHERE 
	schiessanlage.sanierungsstatus = sanierungsstatus.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_schiessanlage AS schiessanlage
SET
	betriebsstatus_txt =  betriebsstatus.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.betriebsstatus AS betriebsstatus
WHERE 
	schiessanlage.betriebsstatus = betriebsstatus.ilicode
;