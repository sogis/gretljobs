SELECT
    objekt_dokument.dokument_id AS t_id, 
    dokument.bezeichnung, 
    dokument.dateiendung,
    objekt_dokument.vegas_id,
    dokument.daten
FROM
    vegas.adm_objekt_dokument AS objekt_dokument
    LEFT JOIN vegas.adm_dokument AS dokument
        ON dokument.dokument_id = objekt_dokument.dokument_id 
;