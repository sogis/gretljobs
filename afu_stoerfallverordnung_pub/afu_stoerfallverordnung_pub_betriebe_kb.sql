SELECT
    CASE
        WHEN konsultationsbereich = 'null_m'
            THEN geometrie
        WHEN konsultationsbereich = 'hundert_m'
            THEN ST_Buffer(geometrie, 100)
        WHEN konsultationsbereich = 'dreihundert_m'
            THEN ST_Buffer(geometrie, 300)
    END AS geometrie,
    'Betriebsareal' AS typ
FROM
    afu_stoerfallverordnung_v1.betriebsareal
;
