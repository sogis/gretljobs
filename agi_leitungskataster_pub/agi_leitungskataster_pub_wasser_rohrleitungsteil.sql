SELECT 
    leitungsknoten.geometrie, 
    rohrleitungsteil.art AS art, 
    leitungsknoten.druckzone, 
    leitungsknoten.symbolori
FROM agi_leitungskataster_was.sia405_wasser_wi_rohrleitungsteil rohrleitungsteil
   LEFT JOIN agi_leitungskataster_was.sia405_wasser_wi_leitungsknoten leitungsknoten ON leitungsknoten.t_id::text = rohrleitungsteil.leitungsknotenref::text
  WHERE leitungsknoten.geometrie IS NOT null
;
