-- Löschung bisheriger Daten --
DELETE FROM
    awjf_rodung_rodungsersatz_mgdm_v1.ersatzmassnahmennl_
;

WITH

-- Selektion Attribute aus Tabelle Flaeche --
ersatzmassnahmennl AS (
    SELECT
        rodungsdaten.nr_kanton,
        flaeche.ersatzmassnahmennl
    FROM 
        awjf_rodung_rodungsersatz_v1.flaeche as flaeche
    LEFT JOIN awjf_rodung_rodungsersatz_v1.rodungsdaten AS rodungsdaten
        ON flaeche.rodung_r = rodungsdaten.t_id
	WHERE
		flaeche.ersatzmassnahmennl IS NOT NULL
	AND 
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

-- Abfüllen der Tabelle Ersatzmassnahmennl_ --
INSERT INTO awjf_rodung_rodungsersatz_mgdm_v1.ersatzmassnahmennl_ (
    avalue,
    rodungsbewilligung_ersatz_massnahmennl
)
    
SELECT
     DISTINCT
        CASE 
            WHEN enl.ersatzmassnahmennl = 'Nein'
                THEN 'N1'
            WHEN enl.ersatzmassnahmennl = 'Gebiet_Waldflaeche_zunehmend'
                THEN 'N2'
            WHEN enl.ersatzmassnahmennl = 'Gebiet_uebrige'
                THEN 'N3'
        END AS avalue,
    rb.t_id AS rodungsbewilligung_ersatz_massnahmennl
FROM
    ersatzmassnahmennl AS enl
JOIN rodungsbewilligung AS rb
    ON enl.nr_kanton = rb.nr_kanton
;