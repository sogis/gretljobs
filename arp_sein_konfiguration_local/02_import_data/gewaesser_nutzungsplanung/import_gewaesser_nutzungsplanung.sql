DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Gewässer (Nutzungsplanung)'
;

WITH

uferschutzzone AS (
	SELECT DISTINCT
		'Gewässer (Nutzungsplanung)' AS thema_sql,
		typ_bezeichnung AS information,
		'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.gewaesser&bl=hintergrundkarte_sw&c=' || 
    	ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '%2C' || 
    	ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '&s=2000' AS link,
		geometrie
	FROM
		pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche_v
	WHERE 
		typ_code_kt IN (527,528)
	AND 
		rechtsstatus = 'inKraft'
),

grundnutzung AS (
	SELECT DISTINCT
		'Gewässer (Nutzungsplanung)' AS thema_sql,
		typ_bezeichnung AS information,
		'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.gewaesser&bl=hintergrundkarte_sw&c=' || 
    	ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '%2C' || 
    	ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '&s=2000' AS link,
		geometrie
	FROM
		pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung_v
	WHERE 
		typ_code_kt IN (320,329,32)
	AND 
		rechtsstatus = 'inKraft'
),

gewaesser_nutzungsplanung AS (
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		uferschutzzone
	UNION ALL
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		grundnutzung
)

--- INSERT INTO Sammeltabelle ---
INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	thema_sql,
	information,
	link,
	geometrie
FROM
	gewaesser_nutzungsplanung
	
