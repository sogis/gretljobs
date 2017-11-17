SELECT 
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    ort_x,
    ort_y,
    nummer,
    typ,hoehe,
    bemerkung,
    nutzen,
    prioritaet,
    frist,
    nr_stg,
    gewaesser,
    gemeinde,
    ortsbezeichnung,
    prio,
    j_20_j_pla,
    massn_nr,
    x_alt_oeko,
    y_alt_oeko
FROM 
    gewisso.san_fischw_nicht_wk
WHERE 
    archive = 0
;