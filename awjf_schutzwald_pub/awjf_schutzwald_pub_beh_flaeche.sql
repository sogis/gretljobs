SELECT
    geometrie,
    id,
    id_schutzwaldprojekt,
    schutzwald_nr,
    flaeche_nr,
    abrechnungs_nr,
    massnahme,
    astatus,
    jahr,
    ST_Area(geometrie)/ 10000 AS flaeche_gemessen,
    flaeche_beitragsberechtigt,
    bemerkung,
    beschriftung
FROM
    awjf_schutzwald_v1.behandelte_flaeche
;
