SELECT
    CASE
        WHEN konsultationsbereich = 'm_100'
            THEN ST_Multi(ST_Union(ST_Buffer(geometrie, 100)))
        WHEN konsultationsbereich = 'm_300'
            THEN ST_Multi(ST_Union(ST_Buffer(geometrie, 300)))
    END AS geometrie,
    'Gasleitung' AS typ
FROM
    afu_stoerfallverordnung_v1.erdgasroehrenspeicher
WHERE
    konsultationsbereich <> 'm_0'
GROUP BY
    konsultationsbereich
;
