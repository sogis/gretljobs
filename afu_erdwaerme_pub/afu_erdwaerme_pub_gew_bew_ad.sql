SELECT DISTINCT 
    anlage.wkb_geometry AS geometrie, 
    anlage.anlageid, 
    erdsonde.statusid, 
    pumpe.pumpeart, 
    bohrung.tiefebohrung AS bohrtiefe, 
    bewilligung.datum_bewilligung, 
    CASE 
        WHEN 
            dokument.doktyp = 4 
                THEN 'https://geo.so.ch/docs/ch.so.afu.erdwaermesonden/'||md5(trim(BOTH '.zip' FROM dokument.name))||'.pdf'
        ELSE 
            'keine'
    END AS name,  
    CASE
        WHEN 
            pumpe.pumpeart = 'eso'
            AND
            doktyp = 4
                THEN 'Erdsonde'
        WHEN
            pumpe.pumpeart = 'eko'
            AND
            doktyp = 4
                THEN 'Erdkollektor'
    END AS objekttyp
FROM 
    gerda.anlage_t AS anlage
    LEFT JOIN gerda.erdsonden AS erdsonde 
        ON anlage.anlageid = erdsonde.anlageid
    LEFT JOIN gerda.pumpe AS pumpe 
        ON anlage.anlageid = pumpe.anlageid
    LEFT JOIN gerda.bohrung AS bohrung
        ON anlage.anlageid = bohrung.anlageid
    LEFT JOIN gerda.bewilligung AS bewilligung 
        ON anlage.anlageid = bewilligung.anlageid
    LEFT JOIN gerda.geschaeft_dokumente AS dokument
        ON anlage.anlageid = dokument.anlageid
WHERE 
    erdsonde.statusid = 89 
    AND 
    anlage.archive = 0 
    AND 
    pumpe.archive = 0 
    AND 
    bewilligung.archive = 0 
    AND 
    bohrung.archive = 0 
    AND 
    dokument.archive = 0
    AND 
    doktyp = 4
;