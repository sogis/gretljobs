SELECT 
    errordescription AS message,
    CASE 
        WHEN errorcategory = 'error' THEN 'Error'
        WHEN errorcategory = 'warning' THEN 'Warning'
        ELSE 'Error'
    END AS atype,
    errorid AS techid,
    ilmodel || '.' || iltopic || '.' || iltable AS iliqname,
    datasetname AS datasource,
    ST_PointFromText('POINT('||errorx||' '||errory||')', 2056) AS ageometry
FROM 
    agi_av_mocheckso.mocheckso_errors_mocheckso_error
WHERE
    errorx != 'NULL'
    AND 
    errory != 'NULL'
;