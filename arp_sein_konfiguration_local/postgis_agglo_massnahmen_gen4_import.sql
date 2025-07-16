WITH

agglomerationsprogramme_gen4_flaeche AS (
	SELECT DISTINCT
		gemeinde.aname AS gemeindename,
		gemeinde.bfsnr,
		'Massnahmen 4. Generation' AS thema_sql,
		agglo.beschreibung AS information,
		agglo.massnahmenblatt AS link
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_flaeche AS agglo
	JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde
		ON ST_Intersects(
			CAST(agglo.flaechengeometrie AS GEOMETRY),
			gemeinde.geometrie
		)
	WHERE 
		agglo.generation = 4
),

agglomerationsprogramme_gen4_punkte AS (
	SELECT DISTINCT
		gemeinde.aname AS gemeindename,
		gemeinde.bfsnr,
		'Massnahmen 4. Generation' AS thema_sql,
		agglo.beschreibung AS information,
		agglo.massnahmenblatt AS link
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_punkt AS agglo
	JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde
		ON ST_Intersects(
			CAST(agglo.punktgeometrie AS GEOMETRY),
			gemeinde.geometrie
		)
	WHERE 
		agglo.generation = 4
),

agglomerationsprogramme_gen4_linie AS (
	SELECT DISTINCT
		gemeinde.aname AS gemeindename,
		gemeinde.bfsnr,
		'Massnahmen 4. Generation' AS thema_sql,
		agglo.beschreibung AS information,
		agglo.massnahmenblatt AS link
	FROM 
		pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_massnahme_linie AS agglo
	JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde
		ON ST_Intersects(
			CAST(agglo.liniengeometrie AS GEOMETRY),
			gemeinde.geometrie
		)
	WHERE 
		agglo.generation = 4
),

agglomerationsprogramme_gen4_all AS (
	SELECT 
		gemeindename,
		bfsnr,
		thema_sql,
		information,
		link
	FROM 
		agglomerationsprogramme_gen4_flaeche
	UNION ALL
	SELECT 
		gemeindename,
		bfsnr,
		thema_sql,
		information,
		link
	FROM 
		agglomerationsprogramme_gen4_punkte
	UNION ALL
	SELECT 
		gemeindename,
		bfsnr,
		thema_sql,
		information,
		link
	FROM 
		agglomerationsprogramme_gen4_linie
)

--- Insert intersecting Agglomerationsprogramme objects ---
INSERT INTO objektinfos_sein_sammeltabelle (
	gemeindename,
	bfsnr,
	thema_sql,
	information,
	link
)

SELECT DISTINCT
	gemeindename,
	bfsnr,
	thema_sql,
	information,
	link
FROM 
	agglomerationsprogramme_gen4_all
;