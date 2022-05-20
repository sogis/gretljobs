INSERT INTO 
	arp_bauzonengrenzen_pub.bauzonengrenzen_bauzonengrenze 
	(
		geometrie,
		bfsnr,
		zonentyp
	)

SELECT 
    ST_Multi(ST_Union(ST_RemoveRepeatedPoints(ST_SnapToGrid(ST_Buffer(geometrie,0), 0.001)))),
    bfs_nr AS bfsnr,
    'Bauzone' AS zonentyp
FROM 
    arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
WHERE 
	bfs_nr = ${bfsnr}
	AND 
	(
		substring(typ_kt from 2 for 2)::int < 20  
	)
GROUP BY
	bfs_nr

UNION ALL

SELECT 
    ST_Multi(ST_Union(ST_RemoveRepeatedPoints(ST_SnapToGrid(ST_Buffer(geometrie,0), 0.001)))),
    bfs_nr AS bfsnr,
    'Reservezone' AS zonentyp
FROM 
    arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
WHERE 
	bfs_nr = ${bfsnr}
	AND 
	(
		substring(typ_kt from 2 for 2)::int = 43
	)
GROUP BY
	bfs_nr
;
