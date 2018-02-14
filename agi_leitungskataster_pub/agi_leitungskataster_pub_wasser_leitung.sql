SELECT
    pk_id AS t_id,
    id,
    baujahr,
    geometrie,
    funktion,
    material,
    material_kurz,
    durchmesser,
    nennweite,
    lagebestimmung,
    status,
    druckzone,
    eigentuemer,
    fontcolor
FROM
    gemgis.t_was_leitung
;