SELECT 
    leitungsknoten.geometrie, 
    absperrorgan.name_nummer, 
    absperrorgan.art AS art, 
    leitungsknoten.druckzone, 
    leitungsknoten.symbolori
FROM agi_leitungskataster_was.sia405_wasser_wi_absperrorgan absperrorgan
    LEFT JOIN agi_leitungskataster_was.sia405_wasser_wi_leitungsknoten leitungsknoten ON leitungsknoten.t_id::text = absperrorgan.leitungsknotenref::text
WHERE leitungsknoten.geometrie IS NOT null
;
