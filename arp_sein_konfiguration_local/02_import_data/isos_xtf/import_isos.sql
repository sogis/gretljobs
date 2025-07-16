WITH

isos_punkte AS (
	SELECT DISTINCT
		'Ortsbild von nationaler Bedeutung ISOS' AS thema_sql,
		hinweis.aname AS information,
		hinweis.url AS link,
		punkt.punkt AS geometrie
	FROM
		bundesinventar_isos.geometrie_punkt AS punkt
	LEFT JOIN bundesinventar_isos.geometrie AS geometrie
		ON punkt.geometrie_punkt = geometrie.T_Id
	LEFT JOIN bundesinventar_isos.geometriekollektion AS kollektion 
		ON geometrie.geometriekollektion_geometrie = kollektion.T_Id 
	LEFT JOIN bundesinventar_isos.hinweisortsbildteil AS hinweisortsbildteil
		ON kollektion.hinweisortsbildteil_geometrie = hinweisortsbildteil.T_Id
	LEFT JOIN bundesinventar_isos.hinweis AS hinweis 
		ON hinweisortsbildteil.hinweis = hinweis.T_Id
),

isos_linien AS (
	SELECT DISTINCT
		'Ortsbild von nationaler Bedeutung ISOS' AS thema_sql,
		hinweis.aname AS information,
		hinweis.url AS link,
		linie.linie AS geometrie
	FROM
		bundesinventar_isos.geometrie_linie AS linie
	LEFT JOIN bundesinventar_isos.geometrie AS geometrie
		ON linie.geometrie_linie = geometrie.T_Id
	LEFT JOIN bundesinventar_isos.geometriekollektion AS kollektion 
		ON geometrie.geometriekollektion_geometrie = kollektion.T_Id 
	LEFT JOIN bundesinventar_isos.hinweisortsbildteil AS hinweisortsbildteil
		ON kollektion.hinweisortsbildteil_geometrie = hinweisortsbildteil.T_Id
	LEFT JOIN bundesinventar_isos.hinweis AS hinweis 
		ON hinweisortsbildteil.hinweis = hinweis.T_Id
),

isos_perimeter AS (
	SELECT DISTINCT
		'Ortsbild von nationaler Bedeutung ISOS' AS thema_sql,
		hinweis.aname AS information,
		hinweis.url AS link,
		perimeter.perimeter AS geometrie
	FROM
		bundesinventar_isos.geometrie_perimeter AS perimeter
	LEFT JOIN bundesinventar_isos.geometrie AS geometrie
		ON perimeter.geometrie_perimeter = geometrie.T_Id
	LEFT JOIN bundesinventar_isos.geometriekollektion AS kollektion 
		ON geometrie.geometriekollektion_geometrie = kollektion.T_Id 
	LEFT JOIN bundesinventar_isos.hinweisortsbildteil AS hinweisortsbildteil
		ON kollektion.hinweisortsbildteil_geometrie = hinweisortsbildteil.T_Id
	LEFT JOIN bundesinventar_isos.hinweis AS hinweis 
		ON hinweisortsbildteil.hinweis = hinweis.T_Id
),

isos_all AS (
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		isos_punkte
	UNION ALL
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		isos_linien
	UNION ALL
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		isos_perimeter
)

--- Insert intersecting objects ---
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
	isos_all
;