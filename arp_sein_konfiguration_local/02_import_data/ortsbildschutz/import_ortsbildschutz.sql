DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Ortsbildschutz (Nutzungsplanung)'
;

WITH

ortsbild_punktobjekt AS (
	SELECT DISTINCT
		'Ortsbildschutz (Nutzungsplanung)' AS thema_sql,
		typ_bezeichnung AS information,
		'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.ortsbildschutz' AS link,
		geometrie
	FROM
		pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_punkt_v
	WHERE 
		rechtsstatus = 'inKraft'
	AND 
		typ_code_kt IN (810,812,813,820,821,822,823)
),

ortsbild_linienobjekt AS (
	SELECT DISTINCT
		'Ortsbildschutz (Nutzungsplanung)' AS thema_sql,
		typ_bezeichnung AS information,
		'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.ortsbildschutz' AS link,
		geometrie
	FROM
		pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_linie_v
	WHERE 
		rechtsstatus = 'inKraft'
),

ortsbild_flaechenobjekt AS (
	SELECT DISTINCT
		'Ortsbildschutz (Nutzungsplanung)' AS thema_sql,
		typ_bezeichnung AS information,
		'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.ortsbildschutz' AS link,
		geometrie
	FROM
		pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche_v
	WHERE 
		rechtsstatus = 'inKraft'
	AND 
		typ_code_kt IN (820,821,822,823,510)
),

denkmal_punktobjekt AS (
	SELECT DISTINCT
		'Ortsbildschutz (Nutzungsplanung)' AS thema_sql,
		objektname AS information,
		objektblatt AS link,
		mpunkt AS geometrie
	FROM
		pubdb.ada_denkmalschutz_pub_v1.denkmal_punkt
	WHERE 
		schutzstufe_code = 'geschuetzt'
),

denkmal_flaechenobjekt AS (
	SELECT DISTINCT
		'Ortsbildschutz (Nutzungsplanung)' AS thema_sql,
		objektname AS information,
		objektblatt AS link,
		mpoly AS geometrie
	FROM
		pubdb.ada_denkmalschutz_pub_v1.denkmal_polygon
	WHERE 
		schutzstufe_code = 'geschuetzt'
),

ortsbildschutz_all AS (
	SELECT 
		thema_sql,
		information,
		link,
		geometrie
	FROM
		ortsbild_punktobjekt
	UNION ALL
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		ortsbild_linienobjekt
	UNION ALL
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		ortsbild_flaechenobjekt
	UNION ALL
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		denkmal_punktobjekt
	UNION ALL
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		denkmal_flaechenobjekt	
)

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT 
	thema_sql,
	information,
	link,
	geometrie
FROM
	ortsbildschutz_all