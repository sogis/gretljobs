-- Löschung bisheriger Daten --
DELETE FROM
    awjf_rodung_rodungsersatz_mgdm_v1.objekt
;

WITH

-- Selektion Attribute aus Tabelle Flaeche --
objekt AS (
    SELECT
        rodungsdaten.nr_kanton,
        flaeche.objekttyp,
        flaeche.massnahmennl_typ,
        flaeche.geometrie
    FROM 
        awjf_rodung_rodungsersatz_v1.flaeche as flaeche
    LEFT JOIN awjf_rodung_rodungsersatz_v1.rodungsdaten AS rodungsdaten
        ON flaeche.rodung_r = rodungsdaten.t_id
	WHERE 
    	rodungsdaten.rodungsentscheid = 'positiv'
	AND 
    	rodungsdaten.datum_entscheid >= '2020-01-01' -- Nur Rodungen, welche ab 01.01.2020 bewilligt wurden, sollen geliefert werden
	AND (
    	rodungsdaten.datum_abschluss_rodung >= NOW() - INTERVAL '10 years' -- Nur Rodungen, welche vor weniger als 10 Jahren abgeschlossen wurden sollen geliefert werden
    	OR rodungsdaten.datum_abschluss_rodung IS NULL
    	)
	AND 
    	flaeche.geometrie IS NOT NULL
),

-- Selektion Attribute aus Tabelle Rodungsbewilligung --
rodungsbewilligung AS (
    SELECT 
        t_id,
        nr_kanton
    FROM awjf_rodung_rodungsersatz_mgdm_v1.rodungsbewilligung
)


-- Abfüllen der Tabelle Massnahmenltyp_ --
INSERT INTO awjf_rodung_rodungsersatz_mgdm_v1.objekt (
    apolygon,
    objekt_typ,
    massnahmennl_typ,
    rodungsbewilligung_objekte
)
  
SELECT
    (ST_Dump(objekt.geometrie)).geom AS apolygon,
    CASE
        WHEN objekt.objekttyp = 'Rodung_temporaer'
            THEN 'G1'
        WHEN objekt.objekttyp = 'Rodung_definitiv'
            THEN 'G2'
        WHEN objekt.objekttyp = 'Realersatz'
            THEN 'G3'
        WHEN objekt.objekttyp = 'MassnahmenNL'
            THEN 'G4'
    END AS objekt_typ,
    CASE 
        WHEN objekt.massnahmennl_typ = 'Vernetzung'
            THEN 'M1'
        WHEN objekt.massnahmennl_typ = 'Revitalisierung'
            THEN 'M2'
        WHEN objekt.massnahmennl_typ = 'Waldrand'
            THEN 'M3'
        WHEN objekt.massnahmennl_typ = 'Biotope'
            THEN 'M4'
        WHEN objekt.massnahmennl_typ = 'Selven'
            THEN 'M5'
        WHEN objekt.massnahmennl_typ = 'Waldreservate'
            THEN 'M6'
        WHEN objekt.massnahmennl_typ = 'Standorte'
            THEN 'M7'
        WHEN objekt.massnahmennl_typ = 'Landschaftsbild'
            THEN 'M8'
        WHEN objekt.massnahmennl_typ = 'Andere'
            THEN 'M9'
    END AS massnahmennl_typ,
    rb.t_id AS rodungsbewilligung_objekte
FROM
    objekt AS objekt
JOIN rodungsbewilligung AS rb
    ON objekt.nr_kanton = rb.nr_kanton
;