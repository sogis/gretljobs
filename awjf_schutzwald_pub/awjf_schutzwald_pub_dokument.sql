SELECT
    geometrie,
    'https://geo.so.ch/docs/ch.so.awjf.schutzwald/'||dokument dokument,
    jahr,
    nais_code,
    beschreibung
FROM
    awjf_schutzwald_v1.dokument
;
