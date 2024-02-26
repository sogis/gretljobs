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
    m.letzte_aenderung AS letzte_aenderung
FROM 
    ${DB_SCHEMA_EDIT}.sia405_lkmap_lklinie AS l
    LEFT JOIN ${DB_SCHEMA_EDIT}.metaattribute AS m
    ON l.t_id = m.sia405_lkmap_lklinie_metaattribute  
;