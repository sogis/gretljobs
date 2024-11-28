-- Löschung bisheriger Daten --
DELETE FROM
    awjf_rodung_rodungsersatz_mgdm_v1.ersatzverzicht_
;

WITH

-- Selektion Attribute aus Tabelle Rodungsdaten --
ersatzverzicht AS (
    SELECT
        nr_kanton,
        unnest(string_to_array(ersatzverzicht, ', ')) AS ersatzverzicht
    FROM 
        awjf_rodung_rodungsersatz_v1.rodungsdaten
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