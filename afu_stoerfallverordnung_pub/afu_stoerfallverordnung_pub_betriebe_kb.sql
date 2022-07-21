SELECT
    CASE
        WHEN konsultationsbereich = 'm_0'
            THEN geometrie
        WHEN konsultationsbereich = 'm_100'
            THEN ST_Buffer(geometrie, 100)
        WHEN konsultationsbereich = 'm_300'
            THEN ST_Buffer(geometrie, 300)
    END AS geometrie,
    'Betriebsareal' AS typ
FROM
    afu_stoerfallverordnung_v1.betriebsareal
;
