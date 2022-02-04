SELECT
    gemeinden.gemeindename, 
    gemeinden.bfs_nr AS bfs_nummer, 
    fff.anrechenbar,
    fff.spezialfall,
	round(sum(ST_area(ST_intersection(fff.geometrie, gemeinden.geometrie)))::NUMERIC, 2)/ 100 AS flaeche,
	round(sum(ST_area(ST_intersection(fff.geometrie, gemeinden.geometrie)))::NUMERIC, 2)/ 100 * anrechenbar AS flaeche_anrechenbar
FROM
	alw_fruchtfolgeflaechen.fruchtfolgeflaeche_clean fff,
	agi_mopublic_pub.mopublic_gemeindegrenze gemeinden
WHERE
	ST_intersects(fff.geometrie,
	gemeinden.geometrie)
GROUP BY
	fff.spezialfall,
	fff.anrechenbar,
	gemeinden.bfs_nr,
	gemeinden.gemeindename
ORDER BY
	gemeindename,
	anrechenbar,
	spezialfall 
;
