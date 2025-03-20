-- Löschung bisheriger Daten --
DELETE FROM
    awjf_rodung_rodungsersatz_mgdm_v1.ersatzverzicht_
;

WITH

-- Selektion Attribute aus Tabelle Rodungsdaten --
ersatzverzicht AS (
    SELECT
        rodungsdaten.nr_kanton,
        rodungsdaten.ersatzverzicht
    FROM 
        awjf_rodung_rodungsersatz_v1.flaeche AS flaeche
    LEFT JOIN awjf_rodung_rodungsersatz_v1.rodungsdaten AS rodungsdaten
        ON flaeche.rodung_r = rodungsdaten.t_id
    WHERE 
    	flaeche.frist >= CURRENT_DATE - INTERVAL '10 years'
	AND
		rodungsdaten.ersatzverzicht IS NOT NULL 
	AND
    	rodungsdaten.rodungsentscheid = 'positiv'
	AND 
    	rodungsdaten.datum_entscheid >= '2020-01-01' -- Nur Rodungen, welche ab 01.01.2020 bewilligt wurden, sollen geliefert werden
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

-- Abfüllen der Tabelle Ersatzverzicht_ --
INSERT INTO awjf_rodung_rodungsersatz_mgdm_v1.ersatzverzicht_ (
    avalue,
    rodungsbewilligung_ersatz_verzicht
)

SELECT
    DISTINCT
    CASE
        WHEN erv.ersatzverzicht = 'Nein'
            THEN 'V1'
        WHEN erv.ersatzverzicht = 'Kulturland'
            THEN 'V2'
        WHEN erv.ersatzverzicht = 'Hochwasserschutz_Revitalisierung'
            THEN 'V3'
        WHEN erv.ersatzverzicht = 'Biotope'
            THEN 'V4'
    END AS avalue,
    rb.t_id AS rodungsbewilligung_ersatz_verzicht
FROM
    ersatzverzicht AS erv
JOIN rodungsbewilligung AS rb
    ON erv.nr_kanton = rb.nr_kanton
;