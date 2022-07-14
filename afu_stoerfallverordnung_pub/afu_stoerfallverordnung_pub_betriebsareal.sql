SELECT
    geometrie,
    konsultationsbereich,
    code.dispname AS konsultationsbereich_txt,
    betriebsname
FROM
    afu_stoerfallverordnung_v1.betriebsareal AS betriebsareal
    LEFT JOIN  afu_stoerfallverordnung_v1.konsultationsbereich AS code
        ON betriebsareal.konsultationsbereich  = code.ilicode
;
