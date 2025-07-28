DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Massnahmen 1. Generation'
;

WITH

agglomerationsprogramme_gen1_flaeche AS (
	SELECT DISTINCT
		'Massnahmen 1. Generation' AS thema_sql,
		beschreibung AS information,
		massnahmenblatt AS link,
		flaechengeometrie AS geometrie
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_flaeche
	WHERE 
		generation = 1
),

agglomerationsprogramme_gen1_punkte AS (
	SELECT DISTINCT
		'Massnahmen 1. Generation' AS thema_sql,
		beschreibung AS information,
		massnahmenblatt AS link,
		punktgeometrie AS geometrie
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_punkt
	WHERE 
		generation = 1
),

agglomerationsprogramme_gen1_linie AS (
	SELECT DISTINCT
		'Massnahmen 1. Generation' AS thema_sql,
		beschreibung AS information,
		massnahmenblatt AS link,
		liniengeometrie AS geometrie
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_linie
	WHERE 
		generation = 1
),

agglomerationsprogramme_gen1_all AS (
	SELECT 
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		agglomerationsprogramme_gen1_flaeche
	UNION ALL
	SELECT 
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		agglomerationsprogramme_gen1_punkte
	UNION ALL
	SELECT 
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		agglomerationsprogramme_gen1_linie
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
	agglomerationsprogramme_gen1_all
;