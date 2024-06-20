WITH mangel_l AS (
    SELECT
        *
    FROM ${DB_SCHEMA_EDIT}.vsadssmini_leitung l
    LEFT JOIN (
        SELECT oid_dss, stilid
        FROM ${DB_SCHEMA_PUB_STAGING}.wk_paa_leitung_se
            UNION ALL
        SELECT oid_dss, stilid
        FROM ${DB_SCHEMA_PUB_STAGING}.wk_paa_leitung_dr 
            UNION ALL
        SELECT oid_dss, stilid
        FROM ${DB_SCHEMA_PUB_STAGING}.wk_saa_leitung_se
            UNION ALL
        SELECT oid_dss, stilid
        FROM ${DB_SCHEMA_PUB_STAGING}.wk_saa_leitung_dr) u
        ON l.t_ili_tid = u.oid_dss
)

INSERT INTO 
    ${DB_SCHEMA_PUB_STAGING}.wk_mangel_leitung  
    (
        oid_dss, 
        verlauf, 
        beschreibung, 
        dataset, 
        stilid
    )
SELECT
    t_ili_tid,
    verlauf,
    'Objektinformationen mangelhaft für korrekte Darstellung',
    t_datasetname,
    'L_mangel'
FROM mangel_L
WHERE stilid IS NULL
;
