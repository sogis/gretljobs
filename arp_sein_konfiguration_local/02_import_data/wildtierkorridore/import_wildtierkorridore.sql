DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Wildtierkorridore'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Wildtierkorridore' AS thema_sql,
	aname AS information,
	objektblatt AS link,
	geometrie
FROM
	pubdb.awjf_wildtierkorridore_pub_v1.wildtierkorridor