SELECT
    pk_id AS t_id,
    tid,
    id,
    detailgeometrie AS geometrie,
    baujahr,
    bezeichnung,
    baulicherzustand,
    eigentuemer,
    status,
    zugaenglichkeit,
    rueckstaukote,
    sohlenkote,
    funktion,
    hochwasserkote,
    sbw_funktion
FROM
    gemgis.t_abw_bauwerk
;