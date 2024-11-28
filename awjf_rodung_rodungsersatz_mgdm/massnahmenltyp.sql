-- Löschung bisheriger Daten --
DELETE FROM
    awjf_rodung_rodungsersatz_mgdm_v1.massnahmenltyp_
;

WITH

-- Selektion Attribute aus Tabelle Flaeche --
massnahmenltyp AS (
    SELECT
        rodungsdaten.nr_kanton,
        flaeche.massnahmennl_typ
    FROM 
        awjf_rodung_rodungsersatz_v1.flaeche as flaeche
    LEFT JOIN awjf_rodung_rodungsersatz_v1.rodungsdaten AS rodungsdaten
        ON flaeche.rodung_r = rodungsdaten.t_id
),

-- Selektion Attribute aus Tabelle Rodungsbewilligung --
rodungsbewilligung AS (
    SELECT 
        t_id,
        nr_kanton
    FROM awjf_rodung_rodungsersatz_mgdm_v1.rodungsbewilligung
)

-- Abfüllen der Tabelle Massnahmenltyp_ --
INSERT INTO awjf_rodung_rodungsersatz_mgdm_v1.massnahmenltyp_ (
    avalue,
    rodungsbewilligung_massnahmennl_typ
)
    
SELECT
    DISTINCT
    CASE 
        WHEN mnlt.massnahmennl_typ = 'Vernetzung'
            THEN 'M1'
        WHEN mnlt.massnahmennl_typ = 'Revitalisierung'
            THEN 'M2'
        WHEN mnlt.massnahmennl_typ = 'Waldrand'
            THEN 'M3'
        WHEN mnlt.massnahmennl_typ = 'Biotope'
            THEN 'M4'
        WHEN mnlt.massnahmennl_typ = 'Selven'
            THEN 'M5'
        WHEN mnlt.massnahmennl_typ = 'Waldreservate'
            THEN 'M6'
        WHEN mnlt.massnahmennl_typ = 'Standorte'
            THEN 'M7'
        WHEN mnlt.massnahmennl_typ = 'Landschaftsbild'
            THEN 'M8'
        WHEN mnlt.massnahmennl_typ = 'Andere'
            THEN 'M9'
        END AS avalue,
    rb.t_id AS rodungsbewilligung_massnahmennl_typ
FROM
    massnahmenltyp AS mnlt
JOIN rodungsbewilligung AS rb
    ON mnlt.nr_kanton = rb.nr_kanton
;