SELECT 
    lknr,
    wkb_geometry,
    CASE 
        WHEN hl_klasse = 'hang_18'
            THEN 'A1'
        WHEN hl_klasse = 'hang_18_35'
            THEN 'A2'
        WHEN hl_klasse = 'hang_35_50'
            THEN 'A3'
        WHEN hl_klasse = 'hang_50'
            THEN 'A4'
    END AS hl_klasse,
    hl_neigung        
FROM alw_bund_hanglagen_allgemein_v1.hl_allgemein
;
