UPDATE
    ${schema}.${table}
SET
    ${attribute}_txt =
        CASE ${attribute}
            WHEN true THEN 'ja'
            WHEN false THEN 'nein'
            WHEN NULL THEN NULL
        END
;
