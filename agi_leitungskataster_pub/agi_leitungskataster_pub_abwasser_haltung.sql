SELECT
    pk_id AS t_id,
    id,
    tid,
    verlauf AS geometrie,
    baujahr,
    bezeichnung,
    baulicherzustand,
    eigentuemer,
    status,
    zugaenglichkeit,
    kote_von,
    kote_nach,
    lichte_hoehe,
    lagebestimmung,
    material,
    material_kurz,
    profil,
    laenge,
    gefaelle,
    funktionhierarchisch,
    funktionhydraulisch,
    nutzungsart,
    spuelintervall,
    fontcolor
FROM
    gemgis.t_abw_haltung
;