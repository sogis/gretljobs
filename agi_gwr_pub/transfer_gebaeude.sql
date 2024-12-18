WITH wohnungen AS 
(
    SELECT 
        egid,
        json_agg(jsonb_build_object(
            '@type', 'SO_AGI_GWR_Publikation_20241118.GWR.Wohnung_',
            'EWID', ewid,
            'EDID', edid,
            'WHGNR', whgnr,
            'WEINR', weinr,
            'WSTWK', wstwk,
            'WSTWK_TXT', wstwk_txt,
            'WMEHRG', wmehrg,
            'WMEHRG_TXT', wmehrg_txt,
            'WBAUJ', wbauj,
            'WBEZ', wbez,
            'WABBJ', wabbj,
            'WSTAT', wstat, 
            'WSTAT_TXT', wstat_txt,
            'WAREA', warea,
            'WAZIM', wazim, 
            'WKCHE', wkche,
            'WKCHE_TXT', wkche_txt
        )) AS wohnungen_json
    FROM 
    (
        SELECT 
            w.egid,
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
    ) AS foo
    GROUP BY 
        foo.egid
)
SELECT 
    g.egid,
    gdekt,
    ggdenr,
    ggdename,
    egrid, 
    lparz,
    lgbkr,
    lparzsx,
    ltyp,
    c1.codtxtkd AS ltyp_txt,
    gebnr,
    gbez,
    gksce,
    c2.codtxtkd AS gksce_txt,
    gstat,
    c3.codtxtkd AS gstat_txt,
    gkat,
    c4.codtxtkd AS gkat_txt,
    gklas,
    c5.codtxtkd AS gklas_txt,
    gbauj,
    gbaum,
    gbaup,
    c6.codtxtkd AS gbaup_txt,
    gabbj,
    garea,
    gvol,
    gvolnorm,
    c7.codtxtkd AS gvolnorm_txt,
    gvolsce, 
    c8.codtxtkd AS gvolsce_txt,
    gastw,
    ganzwhg,
    gazzi,
    CASE 
        WHEN gschutzr = 0 THEN FALSE
        WHEN gschutzr = 1 THEN TRUE
        ELSE NULL::boolean
    END AS gschutzr,
    c9.codtxtkd AS gschutzr_txt,
    gebf,
    gwaerzh1,
    c10.codtxtkd AS gwaerzh1_txt,
    genh1,
    c11.codtxtkd AS genh1_txt,
    gwaersceh1,
    c12.codtxtkd AS gwaersceh1_txt,
    to_date(gwaerdath1, 'YYYY-MM-DD') AS gwaerdath1,
    gwaerzh2,
    c13.codtxtkd AS gwaerzh2_txt,
    genh2,
    c14.codtxtkd AS genh2_txt,
    gwaersceh2,
    c15.codtxtkd AS gwaersceh2_txt,
    to_date(gwaerdath2, 'YYYY-MM-DD') AS gwaerdath2,
    gwaerzw1,
    c16.codtxtkd AS gwaerzw1_txt,
    genw1,
    c17.codtxtkd AS genw1_txt,
    gwaerscew1,
    c18.codtxtkd AS gwaerscew1_txt,
    to_date(gwaerdatw1, 'YYYY-MM-DD') AS gwaerdatw1,
    gwaerzw2,
    c19.codtxtkd AS gwaerzw2_txt,
    genw2,
    c20.codtxtkd AS genw2_txt,
    gwaerscew2,
    c21.codtxtkd AS gwaerscew2_txt,
    to_date(gwaerdatw2, 'YYYY-MM-DD') AS gwaerdatw2,
    to_date(gexpdat, 'YYYY-MM-DD') AS gexpdat,
    w.wohnungen_json AS whng,
    ST_Point(gkode, gkodn, 2056) AS lage
FROM 
    agi_gwr_v1.gwr_gebaeude AS g
    LEFT JOIN agi_gwr_v1.gwr_codes AS c1
    ON (g.ltyp = c1.cecodid AND c1.cmerkm = 'LTYP')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c2
    ON (g.gksce = c2.cecodid AND c2.cmerkm = 'GKSCE')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c3
    ON (g.gstat = c3.cecodid AND c3.cmerkm = 'GSTAT')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c4
    ON (g.gkat = c4.cecodid AND c4.cmerkm = 'GKAT')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c5
    ON (g.gklas = c5.cecodid AND c5.cmerkm = 'GKLAS')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c6
    ON (g.gbaup = c6.cecodid AND c6.cmerkm = 'GBAUP')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c7
    ON (g.gvolnorm = c7.cecodid AND c7.cmerkm = 'GVOLNORM')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c8
    ON (g.gvolsce = c8.cecodid AND c8.cmerkm = 'GVOLSCE')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c9
    ON (g.gschutzr = c9.cecodid AND c9.cmerkm = 'GSCHUTZR')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c10
    ON (g.gwaerzh1 = c10.cecodid AND c10.cmerkm = 'GWAERZH1')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c11
    ON (g.genh1 = c11.cecodid AND c11.cmerkm = 'GENH1')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c12
    ON (g.gwaersceh1 = c12.cecodid AND c12.cmerkm = 'GWAERSCEH1')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c13
    ON (g.gwaerzh2 = c13.cecodid AND c13.cmerkm = 'GWAERZH2')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c14
    ON (g.genh2 = c14.cecodid AND c11.cmerkm = 'GENH2')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c15
    ON (g.gwaersceh2 = c15.cecodid AND c15.cmerkm = 'GWAERSCEH2')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c16
    ON (g.gwaerzw1 = c16.cecodid AND c16.cmerkm = 'GWAERZW1')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c17
    ON (g.genw1 = c17.cecodid AND c17.cmerkm = 'GENW1')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c18
    ON (g.gwaerscew1 = c18.cecodid AND c18.cmerkm = 'GWAERSCEW1')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c19
    ON (g.gwaerzw2 = c19.cecodid AND c19.cmerkm = 'GWAERZW2')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c20
    ON (g.genw2 = c20.cecodid AND c20.cmerkm = 'GENW2')
    LEFT JOIN agi_gwr_v1.gwr_codes AS c21
    ON (g.gwaerscew2 = c21.cecodid AND c21.cmerkm = 'GWAERSCEW2')
    LEFT JOIN wohnungen AS w 
    ON w.egid = g.egid 
;