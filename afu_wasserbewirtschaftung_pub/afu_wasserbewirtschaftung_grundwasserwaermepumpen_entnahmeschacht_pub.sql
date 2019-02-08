SELECT 
    CASE 
        WHEN (objekt.aufnahmedatum < (SELECT date('now') - interval '5 years') AND grundwasserwaerme.zustand = 4) 
            THEN 'alte_voranfrage' 
        WHEN (objekt.aufnahmedatum >= (SELECT date('now') - interval '5 years') AND grundwasserwaerme.zustand = 4) 
            THEN 'neue_voranfrage' 
        WHEN (grundwasserwaerme.schachttyp != 2 AND grundwasserwaerme.zustand != 4) 
            THEN 'Grundwasserwärmepumpe bewilligt'
        ELSE 'unbekannter_Verfahrensstand'
        END AS verfahrensstand, 
        grundwasserwaerme.bezeichnung AS objektname, 
        grundwasserwaerme.vegas_id AS objektnummer, 
        grundwasserwaerme.beschreibung AS technische_angabe, 
        grundwasserwaerme.bemerkung AS bemerkung, 
        array_to_json(dokumente.dokumente) AS dokumente, 
        grundwasserwaerme.wkb_geometry AS geometrie
FROM 
    vegas.obj_grundwasserwaerme grundwasserwaerme,
    vegas.obj_objekt objekt
LEFT JOIN 
    (SELECT 
         array_agg('https://geo.so.ch/docs/ch.so.afu.grundwasserbewirtschaftung/'||y.vegas_id||'_'||x.dokument_id||'.'||x.dateiendung) AS dokumente, 
         y.vegas_id
     FROM 
         vegas.adm_dokument x, 
         vegas.adm_objekt_dokument y 
     WHERE x.dokument_id = y.dokument_id
     GROUP BY y.vegas_id) dokumente ON objekt.vegas_id = dokumente.vegas_id
WHERE 
    grundwasserwaerme.mobj_id = objekt.mobj_id
    AND 
    objekt.objekttyp_id = 18
    AND 
    -- Da der Verfahrensstand zwingend gegeben sein muss, muss sichergestellt werden, dass dieser keinen NULL-Wert enthält! 
    ((grundwasserwaerme.zustand = 4) OR (grundwasserwaerme.schachttyp != 2))
    AND 
    objekt."archive" = 0 
    AND 
    grundwasserwaerme."archive" = 0
;
