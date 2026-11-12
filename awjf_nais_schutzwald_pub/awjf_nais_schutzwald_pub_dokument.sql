SELECT
    geometrie,
    'https://geo.so.ch/docs/ch.so.awjf.schutzwald/'||dokument dokument, --Pfad muss noch auf den neuen umbenannten Ordner geändert werden
    jahr,
    nais_code,
    beschreibung
FROM
    awjf_nais_schutzwald_v1.nais_dokument
;