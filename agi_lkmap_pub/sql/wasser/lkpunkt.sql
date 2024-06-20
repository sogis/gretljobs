WITH beschriftung AS 
(
    SELECT
        p.t_id,
        string_agg(DISTINCT t.textinhalt, '|') AS textinhalt
    FROM 
        ${DB_SCHEMA_EDIT}.sia405_lkmap_lkobjekt_text AS t
        LEFT JOIN ${DB_SCHEMA_EDIT}.sia405_lkmap_lkpunkt AS p 
        ON t.lkobjektref_sia405_lkmap_lkpunkt = p.t_id 
    WHERE 
        t.lkobjektref_sia405_lkmap_lkpunkt IS NOT NULL
        AND 
        t.t_datasetname = ${DATASET}
        AND 
        p.t_datasetname = ${DATASET}
    GROUP BY 
        p.t_id 
)
SELECT 
    t_ili_tid AS t_ili_tid,
    p.symbolpos AS geometrie,
    p.dimension1 AS dimension1,
    p.dimension2 AS dimension2,
    p.symbolori AS symbolori,
    t_ili_tid AS aobjectid,
    p.t_datasetname AS datasetid,
    'Wasser' AS amedium,
    p.objektart AS objektart,
    p.lagebestimmung AS lagebestimmung,
    p.astatus AS astatus,
    p.eigentuemer AS eigentuemer,
    m.datenherr AS datenherr,
    m.datenlieferant AS datenlieferant,
    m.letzte_aenderung AS letzte_aenderung,
    beschriftung.textinhalt
FROM 
    ${DB_SCHEMA_EDIT}.sia405_lkmap_lkpunkt AS p
    LEFT JOIN ${DB_SCHEMA_EDIT}.metaattribute AS m
    ON p.t_id = m.sia405_lkmap_lkpunkt_metaattribute 
    LEFT JOIN beschriftung 
    ON p.t_id = beschriftung.t_id
WHERE 
    p.t_datasetname = ${DATASET}
    AND 
    m.t_datasetname = ${DATASET}
;
