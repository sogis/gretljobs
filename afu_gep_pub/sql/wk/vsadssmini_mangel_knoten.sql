WITH mangel_k AS (
    SELECT
        *
    FROM ${DB_SCHEMA_EDIT}.vsadssmini_knoten k
    LEFT JOIN (
        SELECT oid_dss, stilid
        FROM ${DB_SCHEMA_PUB_STAGING}.paa_schacht_se
            UNION ALL
        SELECT oid_dss, stilid
        FROM ${DB_SCHEMA_PUB_STAGING}.paa_schacht_dr 
            UNION ALL
        SELECT oid_dss, stilid
        FROM ${DB_SCHEMA_PUB_STAGING}.paa_sbw
            UNION ALL
        SELECT oid_dss, stilid
        FROM ${DB_SCHEMA_PUB_STAGING}.saa_schacht_se 
            UNION ALL
        SELECT oid_dss, stilid
        FROM ${DB_SCHEMA_PUB_STAGING}.saa_schacht_dr
            UNION ALL
        SELECT oid_dss, stilid
        FROM ${DB_SCHEMA_PUB_STAGING}.saa_sbw) u
        ON k.t_ili_tid  = u.oid_dss
    WHERE k.funktion NOT IN ('Be_Entlueftung', 'Bodenablauf', 'Dachwasserschacht', 'Entwaesserungsrinne', 'Entwaesserungsrinne_mit_Schlammsack', 'Gelaendemulde', 'Leitungsknoten', 'seitlicherZugang', 'Spuelschacht')
)
INSERT INTO
    ${DB_SCHEMA_PUB_STAGING}.mangel_knoten 
    (
        oid_dss, 
        lage, 
        beschreibung, 
        dataset, 
        stilid
    )
SELECT
    t_ili_tid,
    lage,
    'Objektinformationen mangelhaft für korrekte Darstellung',
    t_datasetname,
    'P_mangel'
FROM mangel_k
WHERE stilid IS NULL
;
