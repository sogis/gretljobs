SELECT
    pk_id AS t_id,
    ogc_fid,
    bw_tid,
    lage AS geometrie,
    baujahr,
    bezeichnung,
    baulicherzustand,
    eigentuemer,
    status,
    zugaenglichkeit,
    deckelkote,
    xkoord,
    ykoord,
    lagegenauigkeit,
    funktion,
    hochwasserkote 
FROM
    gemgis.t_abw_schacht
;