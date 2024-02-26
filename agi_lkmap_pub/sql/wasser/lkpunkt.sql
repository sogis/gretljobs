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
    m.letzte_aenderung AS letzte_aenderung
FROM 
    ${DB_SCHEMA_EDIT}.sia405_lkmap_lkpunkt AS p
    LEFT JOIN ${DB_SCHEMA_EDIT}.metaattribute AS m
    ON p.t_id = m.sia405_lkmap_lkpunkt_metaattribute  
;