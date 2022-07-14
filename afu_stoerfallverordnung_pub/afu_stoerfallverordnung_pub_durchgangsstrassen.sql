SELECT
    geometrie,
    achse_id,
    achsenname,
    achsennummer,
    achsentyp,
    code_achsentyp.dispname AS achsentyp_txt,
    darstellung,
    code_darstellung.dispname AS darstellung_txt,
    konsultationsbereich,
    code_konsultationsbereich.dispname AS konsultationsbereich_txt
FROM
    afu_stoerfallverordnung_v1.durchgangsstrasse AS durchgangsstrasse
    LEFT JOIN  afu_stoerfallverordnung_v1.konsultationsbereich AS code_konsultationsbereich
        ON durchgangsstrasse.konsultationsbereich  = code_konsultationsbereich.ilicode
    LEFT JOIN  afu_stoerfallverordnung_v1.durchgangsstrasse_achsentyp AS code_achsentyp
        ON durchgangsstrasse.achsentyp  = code_achsentyp.ilicode
    LEFT JOIN  afu_stoerfallverordnung_v1.durchgangsstrasse_darstellung AS code_darstellung
        ON durchgangsstrasse.darstellung  = code_darstellung.ilicode
;
