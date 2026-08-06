SELECT
	ara.aname,
	ara.organisation,
	ara.link,
	ara.dim_ew_csb,
	ara.betriebsstatus,
	ara.nummer,
	gemeinde.gemeindename AS gemeindename,
	ara.geometrie
FROM
	afu_klaeranlagen_v1.klaeranlagen_ara AS ara
LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeinde
	ON ST_Within(ara.geometrie, gemeinde.geometrie)
;