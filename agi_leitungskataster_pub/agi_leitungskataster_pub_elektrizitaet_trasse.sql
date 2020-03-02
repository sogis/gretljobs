SELECT 
    t_id, 
    geometrie, 
    name_nummer, 
    art AS art, 
    trassebreite AS breite, 
    lagebestimmung AS lagebestimmung
FROM agi_leitungskataster_ele.sia405_elktrztaet_trasseabschnitt 
WHERE geometrie IS NOT null
;
