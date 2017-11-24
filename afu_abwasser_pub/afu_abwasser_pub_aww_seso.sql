SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    length,
    seso_id,
    durchmesse,
    gefaelle,
    kategorie,
    druckleitu,
    status,
    von_hoehe,
    zu_hoehe,
    baujahr,
    material,
    gemeinde,
    teilgebiet,
    qualitaet,
    archiv_nr,
    erfassung,
    erfasser,
    bearbeitun,
    bearbeiter,
    ofg_connec,
    selekt,
    neg_imp,
    symbol,
    put_erfolg,
    eigentum,
    bemerkunge,
    ara_join 
FROM
    public.aww_seso
WHERE
    archive = 0
;