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

-- Update Information, ob auf dem Grundstück ein Baurecht besteht --
UPDATE hba_immobilienportfolio_pub_v2.immobilienprtflio_grundstuecke AS g
SET
	baurecht = EXISTS (
		SELECT
			1
		FROM
			hba_immobilienportfolio_pub_v2.immobilienprtflio_baurecht AS b
		WHERE
			ST_Intersects(g.geometrie, b.geometrie)
		AND
			ST_Area(ST_Intersection(g.geometrie, b.geometrie)) > 1 -- Damit Flächen, welche sich nur berühren, ausgeschlossen werden können
	);

UPDATE hba_immobilienportfolio_pub_v2.immobilienprtflio_grundstuecke
SET
	baurecht_txt = 
	CASE
		WHEN baurecht
			THEN 'Ja'
		ELSE 'Nein'
END;