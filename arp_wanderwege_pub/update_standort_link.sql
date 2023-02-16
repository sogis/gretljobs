UPDATE
    arp_wanderwege_pub_v1.wanderwege_signalisation
SET
    dokument = 'https://geo-t.so.ch/docs/ch.so.arp.wanderwege/standorttafeln/'||standortname||'.pdf' 
WHERE
    ST_Within(geometrie, (SELECT ST_Union(geometrie) FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze))
AND
    standortname NOT LIKE  '_VZ unbekannt'
AND
    standortname NOT LIKE 'Geissflue'
AND
    standortname NOT LIKE 'Schwang'
AND
    standortname NOT LIKE 'Bärschwil Station'    /*Filename 20221012_27753_1_Bärschwil.pdf, 20221012_28507_1_Bärschwil.pdf */
AND
    standortname NOT LIKE '%Tiefmatt'
AND
    standortname NOT LIKE 'Bättwil'
AND
    standortname NOT LIKE 'Grenchen Süd'
AND
    standortname NOT LIKE 'Höfli'
AND
    standortname NOT LIKE 'Im Holz'
AND
    standortname NOT LIKE '%Selzach, Bahnhof%'
AND
    standortname NOT LIKE '%Niedergösgen%'
AND
    standortname NOT LIKE '_VT Schachen'
AND
    standortname NOT LIKE 'Stierenberg'
AND
    standortname NOT LIKE 'Waldegg'
;
