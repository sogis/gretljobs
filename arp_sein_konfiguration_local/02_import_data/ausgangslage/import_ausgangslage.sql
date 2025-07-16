DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Ausgangslage'
;

WITH

punkte AS (
	SELECT
		'Ausgangslage' AS thema_sql,
		objekttyp AS information,
		dokumente AS link,
		geometrie
	FROM 
		pubdb.arp_richtplan_pub_v2.richtplankarte_ueberlagernder_punkt
	WHERE 
		astatus = 'bestehend'
	AND 
		planungsstand = 'rechtsgueltig'
),

linien AS (
	SELECT
		'Ausgangslage' AS thema_sql,
		objekttyp AS information,
		dokumente AS link,
		geometrie
	FROM 
		pubdb.arp_richtplan_pub_v2.richtplankarte_ueberlagernde_linie
	WHERE 
		astatus = 'bestehend'
	AND 
		planungsstand = 'rechtsgueltig'
	
),

flaechen AS (
	SELECT
		'Ausgangslage' AS thema_sql,
		objekttyp AS information,
		dokumente AS link,
		geometrie
	FROM 
		pubdb.arp_richtplan_pub_v2.richtplankarte_ueberlagernde_flaeche
	WHERE 
		astatus = 'bestehend'
	AND 
		planungsstand = 'rechtsgueltig'
),

richtplan_ausgangslage AS (
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
	richtplan_ausgangslage
;