ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE simiUserOhneVerknuepfung AS
WITH identity AS
(
    SELECT
        si.id,
        si.identifier,
        si.remarks 
    FROM 
        simidb.simi.simiiam_identity si 
        JOIN simidb.simi.simiiam_user su 
        ON su.id = si.id
    WHERE 
        dtype = 'simiIAM_User'
)
SELECT 
    srul.user_id,
    ident.id,
    ident.identifier AS USER,
    ident.remarks
FROM 
    simidb.simi.simiiam_role_user_link srul 
    RIGHT OUTER JOIN identity ident
    ON ident.id = srul.user_id
WHERE 
    srul.user_id IS NULL AND remarks NOT LIKE '%my.so.ch%' AND ident.identifier != 'axiomadev'
ORDER BY 
    ident.identifier
;

COPY simiUserOhneVerknuepfung TO '/tmp/qmbetrieb/simi_user_ohne_verknuepfung.csv' (HEADER, DELIMITER ';');