SELECT
    geometrie,
    aname,
    konsultationsbereich,
    code_konsultationsbereich.dispname AS konsultationsbereich_txt
FROM
    afu_stoerfallverordnung_v1.erdgasroehrenspeicher AS erdgasroehrenspeicher
    LEFT JOIN afu_stoerfallverordnung_v1.konsultationsbereich AS code_konsultationsbereich
        ON erdgasroehrenspeicher.konsultationsbereich  = code_konsultationsbereich.ilicode
;
