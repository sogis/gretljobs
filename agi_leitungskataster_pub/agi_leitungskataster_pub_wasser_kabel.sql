SELECT
    t_id,
    name_nummer,
    geometrie,
    funktion AS funktion_txt,
    kabelart AS kabelart_txt,
    lagebestimmung AS lagebestimmung_txt,
    status AS status_txt,
    einbaujahr,
    ueberdeckung,
    zustand,
    eigentuemer,
    bemerkung,
    letzte_aenderung
FROM
    agi_leitungskataster_was.sia405_wasser_wi_kabel
;
