SELECT 
    w.egid,
    ST_Point(g.gkode, g.gkodn, 2056) AS lage,
    ewid,
    edid,
    whgnr,
    weinr,
    wstwk,
    c1.codtxtkd AS wstwk_txt,
    CASE 
        WHEN wmehrg = 0 THEN FALSE
        WHEN wmehrg = 1 THEN TRUE
        ELSE NULL::boolean
    END AS wmehrg,
    c2.codtxtkd AS wmehrg_txt,
    wbauj,
    wbez,
    wabbj,
    wstat,
    c3.codtxtkd AS wstat_txt,
    warea,
    wazim,
    CASE 
        WHEN wkche = 0 THEN FALSE
        WHEN wkche = 1 THEN TRUE
        ELSE NULL::boolean
    END AS wkche,
    c4.codtxtkd AS wkche_txt,
    to_date(wexpdat, 'YYYY-MM-DD') AS wexpdat
FROM 
    agi_gwr_v1.gwr_wohnung AS w 
    LEFT JOIN agi_gwr_v1.gwr_gebaeude AS g 
    ON w.egid = g.egid 
    LEFT JOIN agi_gwr_v1.gwr_codes AS c1
    ON (w.wstwk = c1.cecodid AND c1.cmerkm = 'WSTWK') 
    LEFT JOIN agi_gwr_v1.gwr_codes AS c2
    ON (w.wmehrg = c2.cecodid AND c2.cmerkm = 'WMEHRG') 
    LEFT JOIN agi_gwr_v1.gwr_codes AS c3
    ON (w.wstat = c3.cecodid AND c3.cmerkm = 'WSTAT') 
    LEFT JOIN agi_gwr_v1.gwr_codes AS c4
    ON (w.wkche = c4.cecodid AND c4.cmerkm = 'WKCHE') 
;