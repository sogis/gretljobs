UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_geogene_bodenbelastung AS geogene_bodenbelastung
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	geogene_bodenbelastung.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_geogene_bodenbelastung AS geogene_bodenbelastung
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	geogene_bodenbelastung.begruendung_aus_vsb_entlassen = begruendung.ilicode
;