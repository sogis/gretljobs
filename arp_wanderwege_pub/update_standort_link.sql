UPDATE
    arp_wanderwege_pub_v1.wanderwege_signalisation
SET
    dokument = 'https://geo-t.so.ch/docs/ch.so.arp.wanderwege/standorttafeln/'||standortname||'.pdf' 
WHERE
    ST_Within(geometrie, (SELECT ST_Union(geometrie) FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze))
;
