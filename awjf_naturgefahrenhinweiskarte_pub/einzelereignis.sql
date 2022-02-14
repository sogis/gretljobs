SELECT
    geometrie AS geometrie,
    datum,
    prozesstyp,
    storme_nummer,
    jahr
FROM
    awjf_naturgefahrenhinweiskarte_v1.einzelereignis AS einzelereignis
;
