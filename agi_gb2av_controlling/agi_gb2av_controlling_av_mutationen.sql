/*
 * AV-Mutationen werden - falls noch nicht vorhanden - in die Tabelle
 * INSERTed. Falls sie bereits vorhanden ist, werden nur die Meldungen
 * vom Grundbuch an die amtliche Vermessung UPDATEd (Attribut 'meldungen').
 * Falls keine Geometrie (proj. Grunstücke) in den Daten der amtlichen Vermessung
 * vorhanden ist, wird kein Record erstellt (siehe WHERE-Clause). Falls keine 
 * AV-Mutationsmeldung vorhanden ist, wird kein Record erstellt.
 */
WITH meldungen AS 
(
    SELECT
        mutationsnummer.nummer,
        mutationsnummer.nbident,
        json_agg(json_build_object
        (
            '@type', 'SO_AGI_GB2AV_Controlling_20201002.Controlling.Vollzugsmeldung',
            'Nummer', mutationsnummer.nummer,
            'NBIdent', mutationsnummer.nbident,
            'Status', vollzugsgegenstand.astatus,
            'Bemerkungen', vollzugsgegenstand.bemerkungen,
            'Grundbucheintrag', TO_DATE(vollzugsgegenstand.grundbucheintrag, 'YYYY-MM-DD'),
            'Tagebucheintrag', TO_DATE(vollzugsgegenstand.tagebucheintrag, 'YYYY-MM-DD'), 
            'Tagebuchbeleg', vollzugsgegenstand.tagebuchbeleg,
            'Datasetname', vollzugsgegenstand.t_datasetname 
        )) AS meldung
    FROM 
        agi_gb2av.vollzugsgegnstnde_vollzugsgegenstand AS vollzugsgegenstand
        LEFT JOIN agi_gb2av.mutationsnummer AS mutationsnummer
        ON mutationsnummer.vollzgsggnszgsggnstand_mutationsnummer = vollzugsgegenstand.t_id 
    GROUP BY 
        mutationsnummer.nummer,
        mutationsnummer.nbident
)
,
mutationen AS 
(
    SELECT 
        mutation.nummer,
        mutation.nbident,
        mutation.beschrieb,
        mutation.dateinameplan,
        CASE 
            WHEN char_length(mutation.endetechnbereit) < 10 THEN TO_DATE(mutation.endetechnbereit, 'YYYYMMDD')
            ELSE TO_DATE(mutation.endetechnbereit, 'YYYY-MM-DD')
        END AS endetechnbereit,
        mutation.istprojektmutation,
        ST_CollectionExtract(ST_Collect(ST_MakeValid(projliegenschaft.geometrie)), 3) AS geometrie    
    FROM 
        agi_dm01avso24.liegenschaften_lsnachfuehrung AS nf
        LEFT JOIN agi_dm01avso24.liegenschaften_projgrundstueck AS projgrundstueck
        ON projgrundstueck.entstehung = nf.t_id 
        LEFT JOIN agi_dm01avso24.liegenschaften_projliegenschaft AS projliegenschaft
        ON projliegenschaft.projliegenschaft_von = projgrundstueck.t_id 
        LEFT JOIN 
        (
            SELECT 
                avmutation.t_id,
                avmutation.t_datasetname,
                mutnummer.nummer,
                mutnummer.nbident,
                avmutation.beschrieb,
                avmutation.dateinameplan,
                avmutation.endetechnbereit,
                avmutation.istprojektmutation
            FROM
                agi_gb2av.mutationstabelle_avmutation AS avmutation
                LEFT JOIN agi_gb2av.mutationsnummer AS mutnummer
                ON avmutation.t_id = mutnummer.mutationstabll_vmttion_mutationsnummer 
        ) AS mutation
        ON mutation.nummer = nf.identifikator AND mutation.nbident = nf.nbident 
    WHERE 
        geometrie IS NOT NULL 
    AND 
        mutation.nummer IS NOT NULL
    GROUP BY 
        mutation.nummer, 
        mutation.nbident,
        mutation.beschrieb,
        mutation.dateinameplan,
        mutation.endetechnbereit,
        mutation.istprojektmutation    
)
INSERT INTO 
    agi_gb2av_controlling.controlling_av2gb_mutationen
    (
        mutationsnummer,
        nbident,
        beschrieb,
        dateinameplan,
        meldungen,
        grundbucheintrag,
        endetechnbereit,        
        perimeter,
        istprojektmutation
    )
    SELECT 
        mutationen.nummer,
        mutationen.nbident,
        mutationen.beschrieb,  
        mutationen.dateinameplan,        
        meldungen.meldung AS meldungen,
        FALSE AS grundbucheintrag,
        mutationen.endetechnbereit,        
        mutationen.geometrie,
        mutationen.istprojektmutation        
    FROM 
        meldungen 
        LEFT JOIN mutationen 
        ON mutationen.nummer = meldungen.nummer AND mutationen.nbident = meldungen.nbident
    WHERE 
        geometrie IS NOT NULL
ON CONFLICT (dateinameplan)
DO 
    UPDATE    
    SET 
        meldungen = EXCLUDED.meldungen,
        grundbucheintrag = EXCLUDED.grundbucheintrag
;

/*
Das Attribut grundbucheintrag kann nicht in der Upsert-Query nachgeführt werden, weil ein Join mit
'agi_gb2av_controlling.controlling_av2gb_mutationen' zu doppelten Records führt, da es ja mehrere Meldungen
geben kann.
*/
WITH subquery AS (
    SELECT 
        t_id
    FROM      
        agi_gb2av_controlling.controlling_av2gb_mutationen,
        jsonb_to_recordset(controlling_av2gb_mutationen.meldungen) AS items("Grundbucheintrag" text, "Datasetname" text)
    WHERE 
        items."Grundbucheintrag" LIKE '20%'
)
UPDATE 
    agi_gb2av_controlling.controlling_av2gb_mutationen
SET 
    grundbucheintrag = TRUE
FROM 
    subquery
WHERE 
    controlling_av2gb_mutationen.t_id = subquery.t_id
;
