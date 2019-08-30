SELECT
    t_id,
    name_nummer,
    geometrie,
    art,
    lagebestimmung,
    hoehe,
    hoehenbestimmung,
    einbaujahr,
    ueberdeckung,
    zustand,
    eigentuemer,
    bemerkung,
    letzte_aenderung,
    t_datasetname AS gem_bfs
FROM
    agi_leitungskataster_was.sia405_wasser_wi_kabelpunkt
;
