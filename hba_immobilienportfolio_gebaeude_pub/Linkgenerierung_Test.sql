SELECT
    '<a href="mailto:' || email_geb ||
    '?subject=' ||
    replace(
        replace(
            replace(
                replace(
                    replace(
                        replace(
                            replace(
                                'Kontaktanfrage Gebäude: ' || "gebaeude_bez",
                                '%', '%25'
                            ),
                            ' ', '%20'
                        ),
                        'ä', '%C3%A4'
                    ),
                    'ö', '%C3%B6'
                ),
                'ü', '%C3%BC'
            ),
            'Ä', '%C3%84'
        ),
        'Ü', '%C3%9C'
    ) ||
    '&amp;body=' ||
    replace(
        replace(
            replace(
                replace(
                    replace(
                        replace(
                            replace(
                                'Guten Tag,' || E'\n\n' ||
                                'Ich habe eine Anfrage zum Gebäude "' ||
                                "gebaeude_bez" || '"' || E'\n\n' ||
                                'Freundliche Grüsse',
                                '%', '%25'
                            ),
                            ' ', '%20'
                        ),
                        E'\n', '%0A'
                    ),
                    'ä', '%C3%A4'
                ),
                'ö', '%C3%B6'
            ),
            'ü', '%C3%BC'
        ),
        'ß', '%C3%9F'
    ) ||
    '">' || verantwortung_geb || '</a>' AS verantwortung_geb_link
FROM hba_immobilienportfolio_gebaeude_v2.gebaeude_csv_import;