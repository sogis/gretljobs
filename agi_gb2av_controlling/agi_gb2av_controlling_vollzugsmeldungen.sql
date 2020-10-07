/*
 * Falls eine Mutation noch nicht vorhanden ist, wird dieses INSERTed. Falls
 * die Mutation bereits in der Tabelle vorhanden ist (Datasetname + Grundstücksart)
 * wird nur das Delta UPDATEd.
 * Das Delta ist die Differenz in Tagen zwischen der Vollzugsmeldung (Eintrag ins Grundbuch)
 * und dem Eintrag des Datums in der amtlichen Vermessung im Attribut gbeintrag.
 * D.h. solange gbeintrag leer ist, wird das Delta UPDATEd.
 * Die Mutation wird erst in die Tabelle eintragen, wenn es auch Geometrien dazu gibt. 
 * Wahrscheinlich gibt es Spezialfälle, wo Mutationen gar nie in der Tabelle gespeichert 
 * werden, weil wir die Daten in der AV nicht haben.
 */
WITH geometrie AS 
(
    SELECT
        nf.identifikator,
        nf.nbident,
        grundstueck.art,
        ST_CollectionExtract(ST_Collect(grundstueck.geometrie),3) AS perimeter
    FROM 
        (
            SELECT
                g.t_id, 
                CASE 
                    WHEN l.geometrie IS NOT NULL THEN ST_MakeValid(ST_CurveToLine(l.geometrie , 6, 0, 1)) 
                    WHEN s.geometrie IS NOT NULL THEN ST_MakeValid(ST_CurveToLine(s.geometrie , 6, 0, 1)) 
                    WHEN b.geometrie IS NOT NULL THEN ST_MakeValid(ST_CurveToLine(b.geometrie , 6, 0, 1)) 
                END AS geometrie,
                g.art,
                g.entstehung 
            FROM agi_dm01avso24.liegenschaften_projgrundstueck AS g
                LEFT JOIN agi_dm01avso24.liegenschaften_projliegenschaft l ON g.t_id=l.projliegenschaft_von 
                LEFT JOIN agi_dm01avso24.liegenschaften_projselbstrecht s ON g.t_id=s.projselbstrecht_von
                LEFT JOIN agi_dm01avso24.liegenschaften_projbergwerk b ON g.t_id=b.projbergwerk_von 
        ) AS grundstueck
        LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung AS nf 
        ON nf.t_id = grundstueck.entstehung
    GROUP BY
        nf.identifikator,
        nf.nbident,
        grundstueck.art
) 
,
geometer AS 
(
    SELECT
        nfgemeinde.bfsnr,
        standort.firma
    FROM
        agi_av_gb_admin_einteilung.nachfuehrngskrise_gemeinde AS nfgemeinde
        LEFT JOIN agi_av_gb_admin_einteilung.nachfuehrngskrise_standort AS standort
        ON nfgemeinde.r_standort = standort.t_id      
),
controlling AS 
(
    SELECT
        EXTRACT(days FROM (NOW() - TO_DATE(gb_grundbucheintrag, 'YYYY-MM-DD'))) AS delta,
        vollzugsgegenstand.gb_mutnummer AS mutationsnummer,
        vollzugsgegenstand.gb_nbident AS nbident,
        vollzugsgegenstand.gb_t_datasetname AS t_datasetname,
        vollzugsgegenstand.gb_status,
        vollzugsgegenstand.gb_bemerkungen,
        TO_DATE(vollzugsgegenstand.gb_grundbucheintrag, 'YYYY-MM-DD') AS gb_grundbucheintrag,
        TO_DATE(vollzugsgegenstand.gb_tagebucheintrag, 'YYYY-MM-DD') AS gb_tagebucheintrag,    
        vollzugsgegenstand.gb_tagebuchbeleg,
        lsnachfuerhung.beschreibung AS av_beschreibung,
        lsnachfuerhung.gueltigkeit AS av_gueltigkeit,
        lsnachfuerhung.gueltigereintrag AS av_gueltigereintrag,
        geometer.firma AS av_firma
    FROM
        (
            SELECT
                vollzugsgegenstand.t_id,
                mutationsnummer.nummer AS gb_mutnummer,
                mutationsnummer.nbident AS gb_nbident,
                vollzugsgegenstand.t_datasetname AS gb_t_datasetname,
                vollzugsgegenstand.astatus AS gb_status,
                vollzugsgegenstand.bemerkungen AS gb_bemerkungen,
                vollzugsgegenstand.grundbucheintrag AS gb_grundbucheintrag,
                vollzugsgegenstand.tagebucheintrag AS gb_tagebucheintrag,
                vollzugsgegenstand.tagebuchbeleg AS gb_tagebuchbeleg
            FROM
                agi_gb2av.vollzugsgegnstnde_vollzugsgegenstand AS vollzugsgegenstand
                LEFT JOIN agi_gb2av.mutationsnummer AS mutationsnummer
                ON mutationsnummer.vollzgsggnszgsggnstand_mutationsnummer = vollzugsgegenstand.t_id
            WHERE
                vollzugsgegenstand.astatus = 'Eintrag'
                AND 
                POSITION('SDR' IN mutationsnummer.nummer) = 0
                AND 
                POSITION('Fl' IN mutationsnummer.nummer) = 0
                AND 
                POSITION('LV95' IN mutationsnummer.nummer) = 0
        ) AS vollzugsgegenstand
        LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung AS lsnachfuerhung
        ON (lsnachfuerhung.nbident = vollzugsgegenstand.gb_nbident AND lsnachfuerhung.identifikator = vollzugsgegenstand.gb_mutnummer)
        LEFT JOIN geometer 
        ON geometer.bfsnr::text = substring(vollzugsgegenstand.gb_nbident, 9, 4)
    WHERE
        gbeintrag IS NULL AND lsnachfuerhung.t_id IS NOT NULL
    ORDER BY 
        gb_grundbucheintrag DESC
)
INSERT INTO 
    agi_gb2av_controlling.controlling_gb2av_vollzugsmeldung_delta
    (
        delta,
        mutationsnummer,
        nbident,
        datasetname,
        gb_status,
        gb_bemerkungen,
        gb_grundbucheintrag,
        gb_tagebucheintrag,
        gb_tagebuchbeleg,
        av_beschreibung,
        av_gueltigkeit,
        av_gueltigereintrag,
        av_firma,
        perimeter,
        grundstuecksart        
    )
    SELECT
        controlling.delta,
        controlling.mutationsnummer,
        controlling.nbident,
        controlling.t_datasetname,
        controlling.gb_status,
        controlling.gb_bemerkungen,
        controlling.gb_grundbucheintrag,
        controlling.gb_tagebucheintrag,
        controlling.gb_tagebuchbeleg,
        controlling.av_beschreibung,
        controlling.av_gueltigkeit,
        controlling.av_gueltigereintrag,
        controlling.av_firma,
        geometrie.perimeter,
        geometrie.art
    FROM
        controlling   
        LEFT JOIN geometrie 
        ON geometrie.identifikator = controlling.mutationsnummer AND geometrie.nbident = controlling.nbident
    WHERE 
        geometrie.perimeter IS NOT NULL
        
ON CONFLICT (datasetname,grundstuecksart)
DO 
    UPDATE    
    SET 
        delta = EXCLUDED.delta     
;

/*
 * UPDATEd das Attribut av_gbeintrag damit man sieht, dass das Geschäft
 * auch in der amtlichen Vermessung vollzogen ist und das Delta nicht
 * mehr UPDATEd wird.
 */
WITH subquery AS 
(
    SELECT 
        identifikator,
        nbident,
        gbeintrag
    FROM 
        agi_dm01avso24.liegenschaften_lsnachfuehrung 
    WHERE 
        gbeintrag IS NOT NULL
)
UPDATE 
    agi_gb2av_controlling.controlling_gb2av_vollzugsmeldung_delta 
SET 
    av_gbeintrag = subquery.gbeintrag
FROM 
    subquery 
WHERE 
    mutationsnummer = subquery.identifikator
    AND agi_gb2av_controlling.controlling_gb2av_vollzugsmeldung_delta.nbident = subquery.nbident
;
