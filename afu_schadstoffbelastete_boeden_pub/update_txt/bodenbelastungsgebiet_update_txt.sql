UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_bodenbelastungsgebiet AS bodenbelastungsgebiet
SET
	belastungsstufe_txt =  belastungsstufe.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_bodenbelastungsgebiet_belastungsstufe AS belastungsstufe
WHERE 
	bodenbelastungsgebiet.belastungsstufe = belastungsstufe.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_bodenbelastungsgebiet AS bodenbelastungsgebiet
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	bodenbelastungsgebiet.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_bodenbelastungsgebiet AS bodenbelastungsgebiet
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	bodenbelastungsgebiet.begruendung_aus_vsb_entlassen = begruendung.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_bodenbelastungsgebiet AS bodenbelastungsgebiet
SET
	flaechentyp_txt =  flaechentyp.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_bodenbelastungsgebiet_flaechentyp AS flaechentyp
WHERE 
	bodenbelastungsgebiet.flaechentyp = flaechentyp.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_bodenbelastungsgebiet AS bodenbelastungsgebiet
SET
	verursacher_txt =  verursacher.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_bodenbelastungsgebiet_verursacher AS verursacher
WHERE 
	bodenbelastungsgebiet.verursacher = verursacher.ilicode
;