SELECT
	ara.aname,
	ara.organisation,
	ara.link,
	ara.dim_ew_csb,
	ara.in_betrieb,
	CASE
		WHEN ara.in_betrieb IS TRUE
			THEN 'Ja'
		WHEN ara.in_betrieb IS FALSE
			THEN 'Nein'
		ELSE NULL
	END AS in_betrieb_txt,
	ara.anlagenummer,
	gemeinde.gemeindename AS gemeindename,
	ara.gewaesser,
	ara.x_einleitstelle,
	ara.y_einleitstelle,
	ara.geometrie
FROM
	afu_klaeranlagen_v1.klaeranlagen_ara AS ara
LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeinde
	ON ST_Within(ara.geometrie, gemeinde.geometrie)
;