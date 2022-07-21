SELECT
    geometrie,
    base_id,
    eigentuemer,
    eigentuemer AS eigentuemer_txt,
    tunnel,
    CASE
        WHEN tunnel IS TRUE
           THEN 'Ja'
        ELSE 'Nein'
    END as tunnel_txt,
    konsultationsbereich,
    code_konsultationsbereich.dispname AS konsultationsbereich_txt
FROM
    afu_stoerfallverordnung_v1.nationalstrasse AS nationalstrasse
    LEFT JOIN  afu_stoerfallverordnung_v1.konsultationsbereich AS code_konsultationsbereich
        ON nationalstrasse.konsultationsbereich  = code_konsultationsbereich.ilicode
    LEFT JOIN  afu_stoerfallverordnung_v1.konsultationsbereich AS code
        ON nationalstrasse.konsultationsbereich  = code.ilicode
;
