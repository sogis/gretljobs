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
    m.letzte_aenderung AS letzte_aenderung
FROM 
    ${DB_SCHEMA_EDIT}.sia405_lkmap_lkflaeche AS f
    LEFT JOIN ${DB_SCHEMA_EDIT}.metaattribute AS m
    ON f.t_id = m.sia405_lkmap_lkflaeche_metaattribute 
;