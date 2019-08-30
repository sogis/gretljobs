SELECT 
    leitung.einbaujahr AS baujahr, 
    leitung.geometrie, 
    leitung.funktion AS funktion, 
    leitung.material AS material, 
    leitung.durchmesser, 
    leitung.nennweite, 
    leitung.lagebestimmung AS lagebestimmung, 
    leitung.status AS status, 
    leitung.druckzone, 
    leitung.eigentuemer, 
        CASE
            WHEN leitung.funktion::text = 'Anschlussleitung.normal'::text THEN '#00FFFF'::text
            WHEN leitung.funktion::text = 'Anschlussleitung.gemeinsam'::text THEN '#00FFFF'::text
            ELSE '#006DFF'::text
        END AS fontcolor
FROM agi_leitungskataster_was.sia405_wasser_wi_leitung leitung
WHERE leitung.geometrie IS NOT null
;
