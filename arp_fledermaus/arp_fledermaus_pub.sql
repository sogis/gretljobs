SELECT 
    beobachtungid AS identifikator,
    'Beobachtung' AS typ,
    artennamedeutsch AS art,
    beobachtunglink AS swissbat_link,
    CAST(NULL AS text) AS quartierstatus,
    ST_SetSRID(ST_MakePoint(x_lv95, y_lv95), 2056) AS geometrie
FROM 
    arp_fledermaus.fledermausfundrte_fledermausfundort   
WHERE 
    beobachtungid IS NOT NULL
    
UNION ALL

SELECT 
    quartierid AS identifikator,
    'Quartier' AS typ,
    artennamedeutsch AS art,
    quartierlink AS swissbat_link,
    CASE 
        WHEN qex IS NOT NULL THEN 'zerstoert'
        WHEN verwaist = 1 THEN 'verwaist'        
        WHEN inaktiv = 1 THEN 'inaktiv'
        ELSE 'aktiv'
    END AS quartierstatus,
    ST_SetSRID(ST_MakePoint(x_lv95, y_lv95), 2056) AS geometrie
FROM 
    arp_fledermaus.fledermausfundrte_fledermausfundort   
WHERE 
    quartierid IS NOT NULL
;