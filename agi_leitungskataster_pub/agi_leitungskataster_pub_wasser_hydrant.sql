SELECT 
    leitungsknoten.geometrie, 
    hydrant.name_nummer, 
    hydrant.art AS art, 
    leitungsknoten.druckzone, 
    hydrant.versorgungsdruck, 
    leitungsknoten.symbolori
FROM agi_leitungskataster_was.sia405_wasser_wi_hydrant hydrant
    LEFT JOIN agi_leitungskataster_was.sia405_wasser_wi_leitungsknoten leitungsknoten ON leitungsknoten.t_id::text = hydrant.leitungsknotenref::text
WHERE leitungsknoten.geometrie IS NOT NULL
;
