UPDATE hba_immobilienportfolio_pub_v2.immobilienprtflio_grundstuecke AS ig
SET
	vermoegensart_txt = ver.dispname
FROM 
	hba_immobilienportfolio_pub_v2.vermoegensart AS ver
WHERE 
	ig.vermoegensart = ver.ilicode
;
	
UPDATE hba_immobilienportfolio_pub_v2.immobilienprtflio_grundstuecke AS ig
SET
	prioritaet_txt = prio.dispname
FROM 
	hba_immobilienportfolio_pub_v2.prioritaetsstufe AS prio
WHERE 
	ig.prioritaet = prio.ilicode 
;