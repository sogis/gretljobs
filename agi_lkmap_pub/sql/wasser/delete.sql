DELETE FROM 
    ${DB_SCHEMA_PUB}.wasser_lkflaeche
WHERE
    datasetid = ${DATASET}
;

DELETE FROM 
    ${DB_SCHEMA_PUB}.wasser_lklinie
WHERE 
    datasetid = ${DATASET}
;

DELETE FROM 
    ${DB_SCHEMA_PUB}.wasser_lkpunkt
WHERE 
    datasetid = ${DATASET}
;
