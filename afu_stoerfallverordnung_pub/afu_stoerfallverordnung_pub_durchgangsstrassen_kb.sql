SELECT
    CASE
        WHEN konsultationsbereich = 'hundert_m'
            THEN ST_Multi(ST_Buffer(geometrie, 100))
        WHEN konsultationsbereich = 'dreihundert_m'
            THEN ST_Multi(ST_Buffer(geometrie, 300))
    END AS geometrie,
    'Durchgangsstrasse' AS typ
FROM
    afu_stoerfallverordnung_v1.durchgangsstrasse
WHERE
    konsultationsbereich <> 'null_m'
;
