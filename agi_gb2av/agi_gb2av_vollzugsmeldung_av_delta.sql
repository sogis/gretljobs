WITH geometer AS 
(
    SELECT
        nfgemeinde.bfsnr,
        grundbuchkreis.nbident,
        standort.firma
    FROM
        agi_av_gb_admin_einteilung.grundbuchkreise_grundbuchkreis AS grundbuchkreis
        LEFT JOIN agi_av_gb_admin_einteilung.nachfuehrngskrise_gemeinde AS nfgemeinde
        ON nfgemeinde.bfsnr = grundbuchkreis.bfsnr
        LEFT JOIN agi_av_gb_admin_einteilung.nachfuehrngskrise_nachfuehrungsgeometer AS nfgeometer
        ON nfgeometer.t_id = nfgemeinde.r_geometer
        LEFT JOIN agi_av_gb_admin_einteilung.nachfuehrngskrise_standort AS standort
        ON standort.t_id = nfgemeinde.r_standort  
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
        ON geometer.nbident = vollzugsgegenstand.gb_nbident
    WHERE
        gbeintrag IS NULL AND lsnachfuerhung.t_id IS NOT NULL
    ORDER BY 
        gb_grundbucheintrag DESC
)
INSERT INTO 
    agi_gb2av.vollzugsmeldung_av_delta
    (
        delta,
        mutationsnummer,
        nbident,
        t_datasetname,
        gb_status,
        gb_bemerkungen,
        gb_grundbucheintrag,
        gb_tagebucheintrag,
        gb_tagebuchbeleg,
        av_beschreibung,
        av_gueltigkeit,
        av_gueltigereintrag,
        av_firma
    )
    SELECT
        delta,
        mutationsnummer,
        nbident,
        t_datasetname,
        gb_status,
        gb_bemerkungen,
        gb_grundbucheintrag,
        gb_tagebucheintrag,
        gb_tagebuchbeleg,
        av_beschreibung,
        av_gueltigkeit,
        av_gueltigereintrag,
        av_firma
    FROM
        controlling   
ON CONFLICT (t_datasetname)
DO 
    UPDATE    
    SET 
        delta = EXCLUDED.delta
;