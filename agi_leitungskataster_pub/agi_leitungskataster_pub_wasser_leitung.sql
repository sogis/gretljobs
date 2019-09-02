SELECT 
    leitung.t_id,
    leitung.t_id AS id,
    leitung.einbaujahr AS baujahr, 
    leitung.geometrie, 
    leitung.funktion AS funktion, 
    leitung.material AS material, 
    CASE
        WHEN leitung.material::text = 'unbekannt'::text THEN 'u'::text
        WHEN leitung.material::text = 'Faserzement.Faserzement'::text THEN 'FZ'::text
        WHEN leitung.material::text = 'Faserzement.Asbestzement'::text THEN 'AZ'::text
        WHEN leitung.material::text = 'Beton_unbekannt'::text THEN 'B'::text
        WHEN leitung.material::text = 'Beton.armiert'::text THEN 'B'::text
        WHEN leitung.material::text = 'Beton.nicht_armiert'::text THEN 'B'::text
        WHEN leitung.material::text = 'Guss.unbekannt'::text THEN 'G'::text
        WHEN leitung.material::text = 'Guss.Grauguss'::text THEN 'GG'::text
        WHEN leitung.material::text = 'Guss.Guss_duktil'::text THEN 'GD'::text
        WHEN leitung.material::text = 'Guss.Ahrens_Guss'::text THEN 'G'::text
        WHEN leitung.material::text = 'Kunststoff.Epoxiharz'::text THEN 'KU'::text
        WHEN leitung.material::text = 'Kunststoff.Glasfaserverstaerkter.Epoxiharz'::text THEN 'KU'::text
        WHEN leitung.material::text = 'Kunststoff.Polypropylen'::text THEN 'PP'::text
        WHEN leitung.material::text = 'Kunststoff.Polyvinylchlorid.unbekannt'::text THEN 'PVC'::text
        WHEN leitung.material::text = 'Kunststoff.Polyvinylchlorid.GFK'::text THEN 'PVC'::text
        WHEN leitung.material::text = 'Kunststoff.Polyvinylchlorid.PVC_hart'::text THEN 'PVC'::text
        WHEN leitung.material::text = 'Kunststoff.Polyvinylchlorid.PVC_U'::text THEN 'PVC'::text
        WHEN leitung.material::text = 'Kunststoff.Polyvinylchlorid.andere'::text THEN 'PVC'::text
        WHEN leitung.material::text = 'Kunststoff.Polyethylen.unbekannt'::text THEN 'PP'::text
        WHEN leitung.material::text = 'Kunststoff.Polyethylen.HDPE'::text THEN 'HDPE'::text
        WHEN leitung.material::text = 'Kunststoff.Polyethylen.MDPE'::text THEN 'MDPE'::text
        WHEN leitung.material::text = 'Kunststoff.Polyethylen.LDPE'::text THEN 'LDPE'::text
        WHEN leitung.material::text = 'Kunststoff.Polyethylen.andere'::text THEN 'PP'::text
        WHEN leitung.material::text = 'Stahl.unbekannt'::text THEN 'STl'::text
        WHEN leitung.material::text = 'Stahl.nicht_rostbestaendig'::text THEN 'STl'::text
        WHEN leitung.material::text = 'Stahl.rostbestaendig'::text THEN 'STl'::text
        WHEN leitung.material::text = 'Stahl.Mannesmann'::text THEN 'STl'::text
        WHEN leitung.material::text = 'Stahl.verzinkt'::text THEN 'STl'::text
        WHEN leitung.material::text = 'Steinzeug'::text THEN 'ST'::text
        WHEN leitung.material::text = 'Ton'::text THEN 'T'::text
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
