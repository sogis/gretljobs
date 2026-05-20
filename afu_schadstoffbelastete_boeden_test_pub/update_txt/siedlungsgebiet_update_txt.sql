UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_siedlungsgebiet AS siedlungsgebiet
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	siedlungsgebiet.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_siedlungsgebiet AS siedlungsgebiet
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	siedlungsgebiet.begruendung_aus_vsb_entlassen = begruendung.ilicode
;