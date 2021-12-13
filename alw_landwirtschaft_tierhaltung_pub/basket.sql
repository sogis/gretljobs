SELECT 
    t_id,
    dataset,
    replace(topic,'SO_ALW_Landwirtschaft_Tierhaltung_20210426','SO_ALW_Landwirtschaft_Tierhaltung_Publikation_restricted_20211019') AS topic,
    t_ili_tid,
    'Datenumbau edit/pub' AS attachmentkey,
    domains
FROM  
    alw_landwirtschaft_tierhaltung_v1.t_ili2db_basket
WHERE
    topic = 'SO_ALW_Landwirtschaft_Tierhaltung_20210426.BFF_Qualitaet' 
      OR
    topic = 'SO_ALW_Landwirtschaft_Tierhaltung_20210426.Betriebsdaten_Strukturdaten'
;