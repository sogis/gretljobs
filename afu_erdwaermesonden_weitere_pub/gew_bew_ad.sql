SELECT 
    geometrie,
    anlage.anlageid, 
    NULL AS statusid, 
    NULL AS pumpeart, 
    bohrtiefe,
    datum_bewilligung, 
    dokument.dokument_url AS name,
    NULL AS anlagedokument, 
    NULL AS doktyp, 
    objekttyp
FROM 
    (SELECT DISTINCT 
        anlage.wkb_geometry AS geometrie, 
        anlage.anlageid, 
        pumpe.pumpeart, 
        bohrung.tiefebohrung AS bohrtiefe, 
        bewilligung.datum_bewilligung,   
        CASE
            WHEN 
                pumpe.pumpeart = 'eso'
                THEN 'Erdsonde'
            WHEN
                pumpe.pumpeart = 'eko'
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
    ORDER BY anlageid
) anlage 
LEFT JOIN 
    (SELECT 
        'https://geo.so.ch/docs/ch.so.afu.erdwaermesonden/'||md5(REPLACE(dok.name,'.zip',''))||'.pdf' AS dokument_url, 
        anlageid
     FROM 
         gerda.geschaeft_dokumente dok
     WHERE 
         doktyp = 4
         AND 
         ARCHIVE = 0) dokument ON anlage.anlageid = dokument.anlageid 
 ORDER BY anlageid
;