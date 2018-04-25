SELECT
    ogc_fid AS t_id,
    fk,
    fr,
    "name",
    sturz,
    rutsch,
    grs,
    lawine,
    anderekt,
    obj_kat,
    schaden_po,
    h_gef_pot,
    igef_pot,
    bemerkunge,
    flaeche,
    fr_ha,
    projher,
    nn,
    anzwe,
    k_wf,
    ST_Multi(wkb_geometry) AS geometrie,
    status
FROM
    awjf.sw_prio
;