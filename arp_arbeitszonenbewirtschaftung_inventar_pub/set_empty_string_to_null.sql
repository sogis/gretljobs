UPDATE 
    arp_arbeitszonenbewirtschaftung_v2.bewertung_bewertung
    SET
    bemerkung = NULLIF(bemerkung, '')
WHERE 
    bemerkung = ''
;