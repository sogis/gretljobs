DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Massnahmen 5. Generation'
;

WITH

agglomerationsprogramme_gen5_flaeche AS (
	SELECT DISTINCT
		'Massnahmen 5. Generation' AS thema_sql,
		beschreibung AS information,
		massnahmenblatt AS link,
		flaechengeometrie AS geometrie
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_flaeche
	WHERE 
		generation = 5
),

agglomerationsprogramme_gen5_punkte AS (
	SELECT DISTINCT
		'Massnahmen 5. Generation' AS thema_sql,
		beschreibung AS information,
		massnahmenblatt AS link,
		punktgeometrie AS geometrie
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_punkt
	WHERE 
		generation = 5
),

agglomerationsprogramme_gen5_linie AS (
	SELECT DISTINCT
		'Massnahmen 5. Generation' AS thema_sql,
		beschreibung AS information,
		massnahmenblatt AS link,
		liniengeometrie AS geometrie
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_linie
	WHERE 
		generation = 5
),

agglomerationsprogramme_gen5_all AS (
	SELECT 
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		agglomerationsprogramme_gen5_flaeche
	UNION ALL
	SELECT 
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		agglomerationsprogramme_gen5_punkte
	UNION ALL
	SELECT 
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		agglomerationsprogramme_gen5_linie
)

--- Insert into Sammeltabelle ---
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
	agglomerationsprogramme_gen5_all
;