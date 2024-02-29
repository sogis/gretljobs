WITH beschriftung AS 
(
    SELECT
        l.t_id,
        string_agg(DISTINCT t.textinhalt, '|') AS textinhalt
    FROM 
        ${DB_SCHEMA_EDIT}.sia405_lkmap_lkobjekt_text AS t
        LEFT JOIN ${DB_SCHEMA_EDIT}.sia405_lkmap_lklinie AS l 
        ON t.lkobjektref_sia405_lkmap_lklinie = l.t_id 
    WHERE 
        t.lkobjektref_sia405_lkmap_lklinie IS NOT NULL
        AND 
        t.t_datasetname = ${DATASET}
        AND 
        l.t_datasetname = ${DATASET}
    GROUP BY 
        l.t_id 
)
SELECT 
    t_ili_tid AS t_ili_tid,
    l.linie AS geometrie,
    l.breite AS breite,
    l.profiltyp AS profiltyp,
    t_ili_tid AS aobjectid,
    l.t_datasetname AS datasetid,
    'Wasser' AS amedium,
    l.objektart AS objektart,
    l.lagebestimmung AS lagebestimmung,
    l.astatus AS astatus,
    l.eigentuemer AS eigentuemer,
    m.datenherr AS datenherr,
    m.datenlieferant AS datenlieferant,
    m.letzte_aenderung AS letzte_aenderung,
    beschriftung.textinhalt
FROM 
    ${DB_SCHEMA_EDIT}.sia405_lkmap_lklinie AS l
    LEFT JOIN ${DB_SCHEMA_EDIT}.metaattribute AS m
    ON l.t_id = m.sia405_lkmap_lklinie_metaattribute  
    LEFT JOIN beschriftung 
    ON l.t_id = beschriftung.t_id
WHERE 
    l.t_datasetname = ${DATASET}
    AND 
    m.t_datasetname = ${DATASET}
;