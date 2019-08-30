SELECT 
    t_id, 
    geometrie, 
    name_nummer, 
    art AS art
FROM agi_leitungskataster_ele.sia405_elktrztaet_trassepunkt 
WHERE geometrie IS NOT null
;
