SELECT 
    leitung.t_id,
    leitung.t_id AS id,
    leitung.einbaujahr AS baujahr, 
    leitung.geometrie, 
    leitung.funktion AS funktion, 
    leitung.material AS material, 
    CASE
        WHEN leitung.material::text = 'unbekannt'::text THEN 'u'::text
        WHEN leitung.material::text = 'Faserzement_Faserzement'::text THEN 'FZ'::text
        WHEN leitung.material::text = 'Faserzement_Asbestzement'::text THEN 'AZ'::text
        WHEN leitung.material::text = 'Beton_unbekannt'::text THEN 'B'::text
        WHEN leitung.material::text = 'Beton_armiert'::text THEN 'B'::text
        WHEN leitung.material::text = 'Beton_nicht_armiert'::text THEN 'B'::text
        WHEN leitung.material::text = 'Guss_unbekannt'::text THEN 'G'::text
        WHEN leitung.material::text = 'Guss_Grauguss'::text THEN 'GG'::text
        WHEN leitung.material::text = 'Guss_Guss_duktil'::text THEN 'GD'::text
        WHEN leitung.material::text = 'Guss_Ahrens_Guss'::text THEN 'G'::text
        WHEN leitung.material::text = 'Kunststoff_Epoxiharz'::text THEN 'KU'::text
        WHEN leitung.material::text = 'Kunststoff_Glasfaserverstaerkter_Epoxiharz'::text THEN 'KU'::text
        WHEN leitung.material::text = 'Kunststoff_Polypropylen'::text THEN 'PP'::text
        WHEN leitung.material::text = 'Kunststoff_Polyvinylchlorid_unbekannt'::text THEN 'PVC'::text
        WHEN leitung.material::text = 'Kunststoff_Polyvinylchlorid_GFK'::text THEN 'PVC'::text
        WHEN leitung.material::text = 'Kunststoff_Polyvinylchlorid_PVC_hart'::text THEN 'PVC'::text
        WHEN leitung.material::text = 'Kunststoff_Polyvinylchlorid_PVC_U'::text THEN 'PVC'::text
        WHEN leitung.material::text = 'Kunststoff_Polyvinylchlorid_andere'::text THEN 'PVC'::text
        WHEN leitung.material::text = 'Kunststoff_Polyethylen_unbekannt'::text THEN 'PP'::text
        WHEN leitung.material::text = 'Kunststoff_Polyethylen_HDPE'::text THEN 'HDPE'::text
        WHEN leitung.material::text = 'Kunststoff_Polyethylen_MDPE'::text THEN 'MDPE'::text
        WHEN leitung.material::text = 'Kunststoff_Polyethylen_LDPE'::text THEN 'LDPE'::text
        WHEN leitung.material::text = 'Kunststoff_Polyethylen_andere'::text THEN 'PP'::text
        WHEN leitung.material::text = 'Stahl_unbekannt'::text THEN 'STl'::text
        WHEN leitung.material::text = 'Stahl_nicht_rostbestaendig'::text THEN 'STl'::text
        WHEN leitung.material::text = 'Stahl_rostbestaendig'::text THEN 'STl'::text
        WHEN leitung.material::text = 'Stahl_Mannesmann'::text THEN 'STl'::text
        WHEN leitung.material::text = 'Stahl_verzinkt'::text THEN 'STl'::text
        WHEN leitung.material::text = 'Steinzeug'::text THEN 'ST'::text
        WHEN leitung.material::text = 'Ton'::text THEN 'T'::text
    ELSE 'u'::text
    END AS material_kurz,
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
