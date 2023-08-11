/** 
 * Gebäude ohne Koordinaten werden nicht berücksichtigt (siehe WHERE-Clause).
 */

SELECT 
    ST_SetSrid(ST_MakePoint(easting::NUMERIC, northing::NUMERIC), 2056) AS geometrie,
    egid,
    CASE 
        WHEN (gebaeudestatus = '') IS NOT FALSE THEN NULL::TEXT
        ELSE gebaeudestatus
    END AS gebaeudestatus_code,
    CASE
        WHEN gebaeudestatus = '1001' THEN 'projektiert'
        WHEN gebaeudestatus = '1002' THEN 'bewilligt'
        WHEN gebaeudestatus = '1003' THEN 'im Bau'
        WHEN gebaeudestatus = '1004' THEN 'bestehend'
        WHEN gebaeudestatus = '1005' THEN 'nicht nutzbar'
        WHEN gebaeudestatus = '1007' THEN 'abgebrochen'
        WHEN gebaeudestatus = '1008' THEN 'nicht realisiert'
    END AS gebaeudestatus,
    CASE 
        WHEN (bauperiode = '') IS NOT FALSE THEN NULL::TEXT
        ELSE bauperiode
    END AS bauperiode_code,
    CASE
        WHEN bauperiode = '8011' THEN 'Vor 1919'
        WHEN bauperiode = '8012' THEN '1919-1945'
        WHEN bauperiode = '8013' THEN '1946-1960'
        WHEN bauperiode = '8014' THEN '1961-1970'
        WHEN bauperiode = '8015' THEN '1971-1980'
        WHEN bauperiode = '8016' THEN '1981-1985'
        WHEN bauperiode = '8017' THEN '1986-1990'
        WHEN bauperiode = '8018' THEN '1991-1995'
        WHEN bauperiode = '8019' THEN '1996-2000'
        WHEN bauperiode = '8020' THEN '2001-2005'
        WHEN bauperiode = '8021' THEN '2006-2010'
        WHEN bauperiode = '8022' THEN '2011-2015'
        WHEN bauperiode = '8023' THEN 'Nach 2015'
    END AS bauperiode,
    CASE 
        WHEN (energie_waermequelle_heizung = '') IS NOT FALSE THEN NULL::TEXT
        ELSE energie_waermequelle_heizung
    END AS energie_waermequelle_heizung_code,
    CASE 
        WHEN energie_waermequelle_heizung = '7500' THEN 'Keine'
        WHEN energie_waermequelle_heizung = '7501' THEN 'Luft'
        WHEN energie_waermequelle_heizung = '7510' THEN 'Erdwärme (generisch)'
        WHEN energie_waermequelle_heizung = '7511' THEN 'Erdwärmesonde'
        WHEN energie_waermequelle_heizung = '7512' THEN 'Erdregister'
        WHEN energie_waermequelle_heizung = '7513' THEN 'Wasser (Grundwasser, Oberflächenwasser, Abwasser)'
        WHEN energie_waermequelle_heizung = '7520' THEN 'Gas'
        WHEN energie_waermequelle_heizung = '7530' THEN 'Heizöl'
        WHEN energie_waermequelle_heizung = '7540' THEN 'Holz (generisch)'
        WHEN energie_waermequelle_heizung = '7541' THEN 'Holz (Stückholz)'
        WHEN energie_waermequelle_heizung = '7542' THEN 'Holz (Pellets)'
        WHEN energie_waermequelle_heizung = '7543' THEN 'Holz (Schnitzel)'
        WHEN energie_waermequelle_heizung = '7550' THEN 'Abwärme (innerhalb des Gebäudes)'
        WHEN energie_waermequelle_heizung = '7560' THEN 'Elektrizität'
        WHEN energie_waermequelle_heizung = '7570' THEN 'Sonne (thermisch)'
        WHEN energie_waermequelle_heizung = '7580' THEN 'Fernwärme (generisch)'
        WHEN energie_waermequelle_heizung = '7581' THEN 'Fernwärme (Hochtemperatur)'
        WHEN energie_waermequelle_heizung = '7582' THEN 'Fernwärme (Niedertemperatur)'
        WHEN energie_waermequelle_heizung = '7598' THEN 'Unbestimmt'
        WHEN energie_waermequelle_heizung = '7599' THEN 'Andere'
    END AS energie_waermequelle_heizung    
FROM 
    agi_gwr_v1.gwr_gebaeude AS g
WHERE 
    (easting = '') IS NOT TRUE
    AND 
    (northing = '') IS NOT TRUE
;