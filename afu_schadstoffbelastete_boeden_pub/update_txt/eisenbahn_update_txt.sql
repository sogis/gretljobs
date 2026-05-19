UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_eisenbahn AS eisenbahn
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	eisenbahn.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_eisenbahn AS eisenbahn
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	eisenbahn.begruendung_aus_vsb_entlassen = begruendung.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_eisenbahn AS eisenbahn
SET
	flaechentyp_txt =  flaechentyp.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_eisenbahn_flaechentyp AS flaechentyp
WHERE 
	eisenbahn.flaechentyp = flaechentyp.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_eisenbahn AS eisenbahn
SET
	verkehrsfrequenz_txt = verkehrsfrequenz.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_eisenbahn_verkehrsfrequenz AS verkehrsfrequenz
WHERE 
	eisenbahn.verkehrsfrequenz = verkehrsfrequenz.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_eisenbahn AS eisenbahn
SET
	verdachtsstreifenbreite_txt = verdachtsstreifenbreite.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_eisenbahn_verdachtsstreifenbreite AS verdachtsstreifenbreite
WHERE 
	eisenbahn.verdachtsstreifenbreite = verdachtsstreifenbreite.ilicode
;