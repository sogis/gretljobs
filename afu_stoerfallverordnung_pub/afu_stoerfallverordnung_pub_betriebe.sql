SELECT
    geometrie,
    konsultationsbereich,
    code.dispname AS konsultationsbereich_txt,
    betriebsname
FROM
    afu_stoerfallverordnung_v1.betrieb AS betrieb
    LEFT JOIN  afu_stoerfallverordnung_v1.konsultationsbereich AS code
        ON betrieb.konsultationsbereich  = code.ilicode
;
