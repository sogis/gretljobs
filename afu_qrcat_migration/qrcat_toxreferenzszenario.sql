SELECT
    id || '§' || stoff AS stoff,
	CASE
	  WHEN "type" = 'f' THEN 'fluessig' 
	  WHEN "type" = 'g' THEN 'gasfoermig'
	END AS typstoff,
	lbrsz100 AS lrsz90_refletalitaetsradius,
	lbrsz10 AS lrsz1_refletalitaetsradius,
	bi AS bi_stoffspez_exponent,
	lw90 AS lw90_letalwert,
	lw1 AS lw1_letalwert
	FROM qrcat.tbl_tox_referenzszenarien;
