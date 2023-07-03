SELECT
    geometrie,
    nutzung,
    waldflaeche,
    waldflaeche::text AS waldflaeche_txt,
    lufttemperatur_04uhr,
    windgeschwindigkeit,
    pet,
    kaltluftprozess,
    kaltluftprozess_code.dispname AS kaltluftprozess_txt,
    kaltluftentstehungsgebiet,
    kaltluftentstehungsgebiet::text AS kaltluftentstehungsgebiet_txt,
    flaeche,
    einwohnerzahl_gesamt,
    einwohner_unter_6_jahren,
    einwohner_ueber_65_jahre,
    einwohnerdichte,
    CASE
        WHEN
            nutzung IN ('Siedlung, Arbeitszone ohne Wohnen', 'Siedlung, bewohnt', 'Verkehrswege und Plätze')
        THEN
            CASE
                WHEN
                    bewertung_tag = 'Sehr_guenstige_bioklimatische_Situation'
                THEN
                    'keine'
                WHEN
                    bewertung_tag = 'Guenstige_bioklimatische_Situation'
                THEN
                    'schwach'
                WHEN
                    bewertung_tag = 'Mittlere_bioklimatische_Situation'
                THEN
                    'mässig'
                WHEN
                    bewertung_tag = 'Unguenstige_bioklimatische_Situation'
                THEN
                    'hoch'
                WHEN
                    bewertung_tag = 'Sehr_unguenstige_bioklimatische_Situation'
                THEN
                    'sehr hoch'
            END
        ELSE
            CASE
                WHEN
                    nutzung = 'Grün- und Freiflächen'
                THEN
                    CASE
                        WHEN
                            bewertung_tag = 'Sehr_hohe_bioklimatische_Bedeutung'
                        THEN
                           'sehr gut'
                        WHEN
                            bewertung_tag = 'Hohe_bioklimatische_Bedeutung'
                        THEN
                           'gut'
                        WHEN
                            bewertung_tag = 'Mittlere_bioklimatische_Bedeutung'
                        THEN
                           'mässig'
                        WHEN
                            bewertung_tag = 'Geringe_bioklimatische_Bedeutung'
                        THEN
                           'ausbaufähig'
                        WHEN
                            bewertung_tag = 'Sehr_geringe_bioklimatische_Bedeutung'
                        THEN
                           'begrenzt'
                    END
            END
    END AS bewertung_tag,
    CASE
        WHEN
            nutzung IN ('Siedlung, Arbeitszone ohne Wohnen', 'Siedlung, bewohnt', 'Verkehrswege und Plätze')
        THEN
            CASE
                WHEN
                    bewertung_nacht = 'Sehr_guenstige_bioklimatische_Situation'
                THEN
                    'keine'
                WHEN
                    bewertung_nacht = 'Guenstige_bioklimatische_Situation'
                THEN
                    'schwach'
                WHEN
                    bewertung_nacht = 'Mittlere_bioklimatische_Situation'
                THEN
                    'mässig'
                WHEN
                    bewertung_nacht = 'Unguenstige_bioklimatische_Situation'
                THEN
                    'hoch'
                WHEN
                    bewertung_nacht = 'Sehr_unguenstige_bioklimatische_Situation'
                THEN
                    'sehr hoch'
            END
        ELSE
            CASE
                WHEN
                    nutzung = 'Grün- und Freiflächen'
                THEN
                    CASE
                        WHEN
                            bewertung_nacht = 'Sehr_hohe_bioklimatische_Bedeutung'
                        THEN
                           'sehr hoch'
                        WHEN
                            bewertung_nacht = 'Hohe_bioklimatische_Bedeutung'
                        THEN
                           'hoch'
                        WHEN
                            bewertung_nacht = 'Mittlere_bioklimatische_Bedeutung'
                        THEN
                           'mässig'
                        WHEN
                            bewertung_nacht = 'Geringe_bioklimatische_Bedeutung'
                        THEN
                           'gering'
                        WHEN
                            bewertung_nacht = 'Sehr_geringe_bioklimatische_Bedeutung'
                        THEN
                           'sehr gering'
                    END
            END
    END AS bewertung_nacht
FROM
    afu_klimaanalyse_v1.ausgangsgroessen_bewertung AS ausgangsgroessen_bewertung
    LEFT JOIN afu_klimaanalyse_v1.ausgangsgroessen_bewertung_kaltluftprozess AS kaltluftprozess_code
      ON kaltluftprozess = kaltluftprozess_code.ilicode
;
