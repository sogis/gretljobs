UPDATE hba_immobilienportfolio_pub_v2.immobilienprtflio_baurecht AS ig
SET
	vermoegensart_txt = ver.dispname
FROM 
	hba_immobilienportfolio_pub_v2.vermoegensart AS ver
WHERE 
	ig.vermoegensart = ver.ilicode
;