UPDATE hba_immobilienportfolio_pub_v2.immobilienprtflio_grundsteucke AS ig
SET
	vermoegensart_txt = ver.dispname
FROM 
	hba_immobilienportfolio_pub_v2.vermoegensart AS ver
WHERE 
	ig.vermoegensart = ver.ilicode
;
	
UPDATE hba_immobilienportfolio_pub_v2.immobilienprtflio_grundsteucke AS ig
SET
	prioritaet_txt = prio.dispname
FROM 
	hba_immobilienportfolio_pub_v2.prioritaetsstufe AS prio
WHERE 
	ig.prioritaet = prio.ilicode
;

UPDATE hba_immobilienportfolio_pub_v2.immobilienprtflio_grundsteucke AS ig
SET
	nutzung_txt = nutzung.dispname
FROM 
	hba_immobilienportfolio_pub_v2.nutzungsart AS nutzung
WHERE 
	ig.nutzung = nutzung.ilicode
;