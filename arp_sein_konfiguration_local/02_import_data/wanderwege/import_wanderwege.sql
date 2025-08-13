DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Wanderwege'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Wanderwege' AS thema_sql,
	wanderweg_typ AS information,
	'https://geo.so.ch/map/?t=default&l=ch.astra.wanderland%2Cch.so.arp.wanderwege.routen%21%2Cch.so.arp.wanderwege.signalisation%21%2Cch.so.arp.wanderwege%2Cch.astra.wanderland-sperrungen_umleitungen&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_LineInterpolatePoint(ST_GeomFromWKB(geometrie),0.5))) || '%2C' || 
    ROUND(ST_Y(ST_LineInterpolatePoint(ST_GeomFromWKB(geometrie),0.5))) || '&s=5000' AS link,
	geometrie
FROM
	pubdb.arp_wanderwege_pub_v1.wanderwege_wanderweg
;