SELECT DISTINCT 
    a.wkb_geometry AS geometrie, 
    a.anlageid, 
    s.statusid, 
    p.pumpeart, 
    bo.tiefebohrung AS bohrtiefe, 
    b.datum_bewilligung, 
    d.dokument, 
    d.name, 
    ((a.anlageid || ''::text) || d.dokumenteid)::integer AS anlagedokument, 
    d.doktyp
FROM 
    gerda.anlage_t a
    LEFT JOIN 
        gerda.erdsonden s 
        ON 
            a.anlageid = s.anlageid
    LEFT JOIN 
        gerda.pumpe p 
        ON 
            a.anlageid = p.anlageid
    LEFT JOIN 
        gerda.bohrung bo 
        ON 
            a.anlageid = bo.anlageid
    LEFT JOIN 
        gerda.bewilligung b 
        ON 
            a.anlageid = b.anlageid
    LEFT JOIN 
        gerda.geschaeft_dokumente d 
        ON 
            a.anlageid = d.anlageid
WHERE 
    s.statusid = 89 
    AND 
    a.archive = 0 
    AND 
    p.archive = 0 
    AND 
    b.archive = 0 
    AND 
    bo.archive = 0 
    AND 
    d.archive = 0;