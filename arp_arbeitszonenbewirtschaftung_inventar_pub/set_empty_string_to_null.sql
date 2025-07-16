UPDATE 
    arp_arbeitszonenbewirtschaftung_v1.bewertung_bewertung
    SET
    bemerkung = NULLIF(bemerkung, '')
WHERE 
    bemerkung = ''
;