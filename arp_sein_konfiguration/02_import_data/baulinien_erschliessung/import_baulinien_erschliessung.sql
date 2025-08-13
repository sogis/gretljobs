DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Baulinien (Erschliessungsplanung)'
;

--- Insert into Sammeltabelle ---
INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Baulinien (Erschliessungsplanung)' AS thema_sql,
	typ_bezeichnung AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.erschliessungsplanung.baulinien&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_LineInterpolatePoint(ST_GeomFromWKB(geometrie),0.5))) || '%2C' || 
    ROUND(ST_Y(ST_LineInterpolatePoint(ST_GeomFromWKB(geometrie),0.5))) || '&s=1000' AS link,
	geometrie
FROM 
	pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_erschliessung_linienobjekt_v
;