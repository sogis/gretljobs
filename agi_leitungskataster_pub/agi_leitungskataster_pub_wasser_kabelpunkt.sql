SELECT
    t_id,
    name_nummer,
    geometrie,
    art AS art_txt,
    lagebestimmung AS lagebestimmung_txt,
    hoehe,
    hoehenbestimmung AS hoehenbestimmung_txt,
    einbaujahr,
    ueberdeckung,
    zustand,
    eigentuemer,
    bemerkung,
    letzte_aenderung
FROM
    agi_leitungskataster_was.sia405_wasser_wi_kabelpunkt
;
