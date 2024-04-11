WITH beschriftung AS 
(
    SELECT
        f.t_id,
        string_agg(DISTINCT t.textinhalt, '|') AS textinhalt
    FROM 
        ${DB_SCHEMA_EDIT}.sia405_lkmap_lkobjekt_text AS t
        LEFT JOIN ${DB_SCHEMA_EDIT}.sia405_lkmap_lkflaeche AS f
        ON t.lkobjektref_sia405_lkmap_lkflaeche = f.t_id 
    WHERE 
        t.lkobjektref_sia405_lkmap_lkflaeche IS NOT NULL
        AND 
        t.t_datasetname = ${DATASET}
        AND 
        f.t_datasetname = ${DATASET}
    GROUP BY
        f.t_id 
)
SELECT 
    t_ili_tid AS t_ili_tid,
    f.flaeche AS geometrie,
    t_ili_tid AS aobjectid,
    f.t_datasetname AS datasetid,
    'Wasser' AS amedium,
    f.objektart AS objektart,
    f.lagebestimmung AS lagebestimmung,
    f.astatus AS astatus,
    f.eigentuemer AS eigentuemer,
    m.datenherr AS datenherr,
    m.datenlieferant AS datenlieferant,
    m.letzte_aenderung AS letzte_aenderung,
    beschriftung.textinhalt
FROM 
    ${DB_SCHEMA_EDIT}.sia405_lkmap_lkflaeche AS f
    LEFT JOIN ${DB_SCHEMA_EDIT}.metaattribute AS m
    ON f.t_id = m.sia405_lkmap_lkflaeche_metaattribute 
    LEFT JOIN beschriftung 
    ON f.t_id = beschriftung.t_id
WHERE 
    f.t_datasetname = ${DATASET}
    AND 
    m.t_datasetname = ${DATASET}
;