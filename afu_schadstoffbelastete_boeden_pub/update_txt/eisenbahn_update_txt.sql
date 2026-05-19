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


	

	
	
-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_flugplatz --
	
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
	
	
-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_gaertnerei --
	
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
	
	
-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_geogene_bodenbelastung --

	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
	
	
-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_hopfenbau --
	
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
	

-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_militaerischer_schiessplatz --
	
	schiessplatz_betriebsstatus.description AS betriebsstatus_txt,
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
	
	
-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_pfas --
	
	status.description AS status_txt, -- prüfen ob dies hier richtig ist
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt -- prüfen ob das hier richtig ist
	
	
-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_rebbau --
	
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
	
	
-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_schiessanlage --

	schiessanlage_trennkriterium.description AS trennkriterium_txt,
	lage.aname AS lage_txt,
	schiessanlage_sanierungsstatus.description AS sanierungsstatus_txt,
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
	
-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_schrebergarten --
	
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt


-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_siedlungsgebiet --
	
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt


-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_stahlbruecke --
	
	stahlbruecke_brueckentyp.description AS brueckentyp_txt,
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
	

-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_stahlkonstruktion --
	
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
	
	
-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_stahlmast --
	
	stahlmast_radius.description AS radius_txt,
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
	

-- afu_schadstoffbelastete_boeden_pub_schdstfflstt_bden_strasse --
	
	strasse_strassentyp.description AS strassentyp_txt,
	strasse_verkehrsfrequenz.description AS verkehrsfrequenz_txt,
	strasse_verdachtsstreifenbreite.description AS verdachtsstreifenbreite_txt,
	status.description AS status_txt,
	begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt