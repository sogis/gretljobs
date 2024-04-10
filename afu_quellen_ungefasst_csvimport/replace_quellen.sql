WITH 

existing AS (
    SELECT 
        q.id_quelle
    FROM 
        ${editSchema}.quelle_ungefasst q
    JOIN 
        ${stageSchema}.csv_import i ON q.id_quelle = i.id_quelle
),

delete_existing AS (
    DELETE FROM 
        ${editSchema}.quelle_ungefasst q
    USING 
        existing
    WHERE 
        q.id_quelle = existing.id_quelle
)

INSERT INTO 
    ${editSchema}.quelle_ungefasst (
        id_quelle, 
        flurname, 
        quellenname, 
        hoehe, 
        austrittsform, 
        quellgroesse, 
        schuettungsverhalten, 
        quellschuettung, 
        vernetzung,
        austrittsanzahl, 
        bemerkungen, 
        fassung, 
        wasserentnahme, 
        trittschaeden, 
        sommerbeschattung, 
        substrate, 
        revitobjekt, 
        gesamtbewertung,
        punkt,
        datum,
        gemeindename,
        x_koordinate,
        y_koordinate,
        bioerhebung,
        importdatum,
        dok_url       
    )
SELECT 
    id_quelle, 
    flurname, 
    quellenname, 
    hoehe, 
    austrittsform, 
    quellgroesse, 
    schuettungsverhalten, 
    quellschuettung, 
    vernetzung,
    austrittsanzahl, 
    bemerkungen, 
    fassung, 
    wasserentnahme, 
    trittschaeden, 
    sommerbeschattung, 
    substrate, 
    revitobjekt, 
    gesamtbewertung,
    punkt,
    datum,
    gemeindename,
    x_koordinate,
    y_koordinate,
    bioerhebung,
    importdatum,
    concat('https://afu.so.ch/', id_quelle, '.pdf') AS dok_url  
FROM 
    ${stageSchema}.csv_import
;