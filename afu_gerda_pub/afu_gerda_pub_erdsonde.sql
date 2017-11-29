SELECT 
    anlage.anlageid AS t_id, 
    anlage.wkb_geometry95 AS geometrie, 
    voranfrage.statusid, 
    CASE
        WHEN dok.doktyp = 4 
            THEN 'vorhanden'::text
        ELSE 'nicht vorhanden'::text
    END AS bohrprofil, 
    CASE
        WHEN 
            bohr.pumpeart IS NULL 
            OR 
            bohr.pumpeid <= 4325 
            AND 
            bohr.new_date < '2010-09-27 00:00:00'::timestamp without time zone 
            THEN voranfrage.anltyp
        ELSE bohr.pumpeart
    END AS anltyp, 
    CASE
        WHEN (bohr.anz_bohrloecher::numeric * bohr.tiefebohrung) IS NULL 
            THEN 0::numeric
        ELSE bohr.anz_bohrloecher::numeric * bohr.tiefebohrung
    END AS gesamttiefe
FROM ( 
    SELECT 
        anlage_t.anlageid, 
        anlage_t.wkb_geometry95
    FROM 
        gerda.anlage_t
    WHERE 
        anlage_t.archive = 0) AS anlage
    LEFT JOIN ( 
        SELECT 
            voranfrage.anlageid, 
            voranfrage.statusid, 
            code.kurztext AS anltyp
        FROM 
            gerda.voranfrage
            LEFT JOIN gerda.code 
                ON voranfrage.anltyp = code.codeid) AS voranfrage 
        ON anlage.anlageid = voranfrage.anlageid
    LEFT JOIN ( 
        SELECT 
            bohrung.anlageid, 
            bohrung.tiefebohrung, 
            pumpe.pumpeid, 
            pumpe.anzahl AS anz_bohrloecher, 
            pumpe.pumpeart, 
            pumpe.new_date
        FROM 
            gerda.bohrung
            LEFT JOIN gerda.pumpe 
                ON bohrung.anlageid = pumpe.anlageid
        WHERE 
            bohrung.archive = 0 
            AND 
            pumpe.archive = 0) AS bohr 
        ON anlage.anlageid = bohr.anlageid
    LEFT JOIN ( 
        SELECT 
            geschaeft_dokumente.anlageid, 
            geschaeft_dokumente.doktyp
        FROM 
            gerda.geschaeft_dokumente
        WHERE 
            geschaeft_dokumente.archive = 0 
            AND 
            geschaeft_dokumente.doktyp = 4) AS dok 
        ON anlage.anlageid = dok.anlageid
;