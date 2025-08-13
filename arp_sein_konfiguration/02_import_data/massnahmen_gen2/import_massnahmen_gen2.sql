DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Massnahmen 2. Generation'
;

WITH

agglomerationsprogramme_gen2_flaeche AS (
	SELECT DISTINCT
		'Massnahmen 2. Generation' AS thema_sql,
		beschreibung AS information,
		massnahmenblatt AS link,
		flaechengeometrie AS geometrie
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_flaeche
	WHERE 
		generation = 2
),

agglomerationsprogramme_gen2_punkte AS (
	SELECT DISTINCT
		'Massnahmen 2. Generation' AS thema_sql,
		beschreibung AS information,
		massnahmenblatt AS link,
		punktgeometrie AS geometrie
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_punkt
	WHERE 
		generation = 2
),

agglomerationsprogramme_gen2_linie AS (
	SELECT DISTINCT
		'Massnahmen 2. Generation' AS thema_sql,
		beschreibung AS information,
		massnahmenblatt AS link,
		liniengeometrie AS geometrie
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_linie
	WHERE 
		generation = 2
),

agglomerationsprogramme_gen2_all AS (
	SELECT 
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		agglomerationsprogramme_gen2_flaeche
	UNION ALL
	SELECT 
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		agglomerationsprogramme_gen2_punkte
	UNION ALL
	SELECT 
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		agglomerationsprogramme_gen2_linie
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
	agglomerationsprogramme_gen2_all
;