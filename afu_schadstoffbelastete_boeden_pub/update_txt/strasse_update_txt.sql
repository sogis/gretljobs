UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_strasse AS strasse
SET
	astatus_txt =  status.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_status AS status
WHERE 
	strasse.astatus = status.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_strasse AS strasse
SET
	begruendung_aus_vsb_entlassen_txt =  begruendung.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen AS begruendung
WHERE 
	strasse.begruendung_aus_vsb_entlassen = begruendung.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_strasse AS strasse
SET
	strassentyp_txt =  strassentyp.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_strasse_strassentyp AS strassentyp
WHERE 
	strasse.strassentyp = strassentyp.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_strasse AS strasse
SET
	verkehrsfrequenz_txt =  verkehrsfrequenz.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_strasse_verkehrsfrequenz AS verkehrsfrequenz
WHERE 
	strasse.verkehrsfrequenz = verkehrsfrequenz.ilicode
;

UPDATE afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_strasse AS strasse
SET
	verdachtsstreifenbreite_txt =  verdachtsstreifenbreite.dispname
FROM
	afu_schadstoffbelastete_boeden_pub_v1.schdstfstt_bden_strasse_verdachtsstreifenbreite AS verdachtsstreifenbreite
WHERE 
	strasse.verdachtsstreifenbreite = verdachtsstreifenbreite.ilicode
;