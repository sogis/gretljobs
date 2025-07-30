DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Vorhaben'
;

WITH

punkte AS (
	SELECT
		'Vorhaben' AS thema_sql,
		objekttyp AS information,
		dokumente AS link,
		geometrie
	FROM 
		pubdb.arp_richtplan_pub_v2.richtplankarte_ueberlagernder_punkt
	WHERE 
		astatus = 'neu'
	AND 
		planungsstand = 'rechtsgueltig'
),

linien AS (
	SELECT
		'Vorhaben' AS thema_sql,
		objekttyp AS information,
		dokumente AS link,
		geometrie
	FROM 
		pubdb.arp_richtplan_pub_v2.richtplankarte_ueberlagernde_linie
	WHERE 
		astatus = 'neu'
	AND 
		planungsstand = 'rechtsgueltig'
	
),

flaechen AS (
	SELECT
		'Vorhaben' AS thema_sql,
		objekttyp AS information,
		dokumente AS link,
		geometrie
	FROM 
		pubdb.arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche
	WHERE 
		astatus = 'neu'
	AND 
		planungsstand = 'rechtsgueltig'
),

richtplan_vorhaben AS (
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		punkte
	UNION ALL
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		linien
	UNION ALL
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM 
		flaechen
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
	richtplan_vorhaben
;