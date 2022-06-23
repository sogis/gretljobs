UPDATE
    ${schema}.${table}
SET
    ${attribute}_txt =
    (
        SELECT
            ${schema}.${enumTable}.dispname
        FROM
            ${schema}.${enumTable}
        WHERE
            ${schema}.${enumTable}.ilicode = ${schema}.${table}.${attribute}
    )
;
