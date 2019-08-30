SELECT
    t_id,
    name_nummer,
    geometrie,
    funktion,
    kabelart,
    lagebestimmung,
    status,
    einbaujahr,
    ueberdeckung,
    zustand,
    eigentuemer,
    bemerkung,
    letzte_aenderung,
    t_datasetname AS gem_bfs
FROM
    agi_leitungskataster_was.sia405_wasser_wi_kabel
;
