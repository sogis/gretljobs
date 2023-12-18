DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten
;

WITH altlasten AS (
    SELECT 
        ST_union(geometrie) AS geometrie
    FROM 
        afu_altlasten_pub.belasteter_standort
    WHERE 
        "bewertung" in ('unbelastet',
                        'Belastet, weder überwachungs- noch sanierungsbedürftig',
                        'Belastet, überwachungsbedürftig',
                        'Belastet, untersuchungsbedürftig',
                        'Belastet, sanierungsbedürftig',
                        'Belastet, keine schädlichen oder lästigen Einwirkungen zu erwarten')
)

SELECT 
    ST_difference(fff_bodenbedeckung.geometrie,altlasten.geometrie) AS geometrie
INTO 
    alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten 
FROM 
    alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung fff_bodenbedeckung,
    altlasten
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_altlasten_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten
USING GIST(geometrie)
;
